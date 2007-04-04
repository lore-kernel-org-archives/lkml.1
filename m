Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbXDDVEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbXDDVEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXDDVEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:04:07 -0400
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:40172 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXDDVEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:04:06 -0400
Message-ID: <461412C2.8090201@tremplin-utc.net>
Date: Wed, 04 Apr 2007 23:04:02 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Vincent Vanackere <vincent.vanackere@gmail.com>
Cc: Karl Pickett <karl.pickett@gmail.com>, linux-kernel@vger.kernel.org,
       inux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] Make ati_remote button repeat sensitivity soft-configurable
References: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>	 <461357D8.8060608@tremplin-utc.net>	 <65258a580704040145m6eb7108frfa8197d3b88e207a@mail.gmail.com>	 <f9be06770704040637k419a7fd7t2cdd52186d91ad5f@mail.gmail.com>	 <f9be06770704040821h6d96e703hf405335fa73f289b@mail.gmail.com> <65258a580704041352q664f5da2xeaeec1a82819d9ef@mail.gmail.com>
In-Reply-To: <65258a580704041352q664f5da2xeaeec1a82819d9ef@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

04/04/2007 10:52 PM, Vincent Vanackere wrote/a écrit:
:
> I'm attaching a very small adaptation of your patch (re-added the
> repeat_count check and a small comment, compile & run-time tested).
> Works fine for me...

> 
> --- drivers/usb/input/ati_remote.c.orig	2007-04-04 22:05:10.000000000 +0200
> +++ drivers/usb/input/ati_remote.c	2007-04-04 22:35:59.000000000 +0200
:
> @@ -174,6 +179,8 @@
>  	unsigned char old_data[2];  /* Detect duplicate events */
>  	unsigned long old_jiffies;
>  	unsigned long acc_jiffies;  /* handle acceleration */
> +        unsigned long first_jiffies;
    ^^^^^^^^ space warning!

Sorry for being annoying ;-)
Eric
