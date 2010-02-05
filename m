Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab0BERwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:52:45 -0500
Received: from senator.holtmann.net ([87.106.208.187]:46133 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab0BERwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:52:44 -0500
Subject: Re: [PATCH] Bluetooth: Keep a copy of each HID device's report
 descriptor.
From: Marcel Holtmann <marcel@holtmann.org>
To: Michael Poole <mdpoole@troilus.org>
Cc: Bastien Nocera <hadess@hadess.net>, Jiri Kosina <jkosina@suse.cz>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <87vdebfvfk.fsf@troilus.org>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	 <1264783166.29532.5302.camel@localhost.localdomain>
	 <87iqakifm8.fsf@troilus.org>
	 <1264860663.29532.7887.camel@localhost.localdomain>
	 <871vh1gpaz.fsf_-_@troilus.org>
	 <1265293390.31341.156.camel@localhost.localdomain>
	 <87vdebfvfk.fsf@troilus.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 09:51:43 -0800
Message-ID: <1265392303.31341.235.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

> > looks good to me. I just prefer that you do the allocation of the report
> > descriptor before the HID object:
> 
> An updated patch is below.  Sorry for the delay -- inclement weather
> here got in the way of testing this as quickly as I would have liked.
> 
> From e245ef87247f5e257db40c412af7991c9af375ab Mon Sep 17 00:00:00 2001
> From: Michael Poole <mdpoole@troilus.org>
> Date: Fri, 5 Feb 2010 12:21:38 -0500
> Subject: [PATCH] Bluetooth: Keep a copy of each HID device's report descriptor.
> 
> The report descriptor is read by user space (via the Service
> Discovery Protocol), so it is only available during the ioctl
> to connect.  However, the probe function that needs the
> descriptor might not be called until a specific module is
> loaded.  Keep a copy of the descriptor so it is available for
> later use.

patch has been applied. Thanks.

Regards

Marcel


