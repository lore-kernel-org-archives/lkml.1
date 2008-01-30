Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYA3MiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYA3MiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 07:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbYA3MiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 07:38:05 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:4266 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYA3MiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 07:38:04 -0500
X-IronPort-AV: E=Sophos;i="4.25,277,1199682000"; 
   d="scan'208";a="47632676"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] [Blackfin] char driver for Blackfin on-chip OTP memory
Date: Wed, 30 Jan 2008 07:39:20 -0500
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
References: <1201689401-2892-1-git-send-email-bryan.wu@analog.com> <47A058B3.6000009@gmail.com>
In-Reply-To: <47A058B3.6000009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801300739.21344.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 30 Jan 2008 12:38:02.0090 (UTC) FILETIME=[F3E1ACA0:01C8633C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30 Jan 2008 06:00, Jiri Slaby pondered:
> On 01/30/2008 11:36 AM, Bryan Wu wrote:
> > From: Mike Frysinger <michael.frysinger@analog.com>
> > 
> > initial char driver for otp memory
> > (only read supported atm ... needs real examples/docs for write support)
> > 
> > Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>

> > +	bfin_otp_class = class_create(THIS_MODULE, "otp");
> > +	device_create(bfin_otp_class, NULL, bfin_otp_dev_node, "otp");
> 
> Anyway, wouldn't be easier/better to use misc.c functionality here 
> (misc_register() et al.)?

OTP (one time programmable) memory are not registers, they are small blocks 
(8k bytes) of non violate on chip memory, for storing things that you don't 
want other people to look at via a PCB level probe. (like keys), or things 
that are just helpful - like MAC addresses.

-Robin
