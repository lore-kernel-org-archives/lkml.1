Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbXHCUDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbXHCUDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbXHCUDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:03:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683AbXHCUDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:03:41 -0400
Date: Fri, 3 Aug 2007 13:04:59 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Greg KH <gregkh@suse.de>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Only enable autosuspend by default on certain
 device classes
Message-Id: <20070803130459.cdd964b7.zaitcev@redhat.com>
In-Reply-To: <20070803194532.GD16604@redhat.com>
References: <20070802235613.GA9487@srcf.ucam.org>
	<20070803011505.GA32589@suse.de>
	<20070803014756.GA10392@srcf.ucam.org>
	<200708030957.46320.oliver@neukum.org>
	<20070803142416.GB11942@redhat.com>
	<20070803123447.00374108.zaitcev@redhat.com>
	<20070803194532.GD16604@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007 15:45:32 -0400, Dave Jones <davej@redhat.com> wrote:

>  > > My experience suggests the opposite.  Of the several I've tried so far,
>  > > none have worked with usb suspend.
>  > 
>  > All of mine work. I'm wondering if this has something to do with
>  > a hub or motherboard... How should we test it? Tried plugging elsewhere?
> 
> no hubs involved, directly plugged them into the mainboard.
> Fairly recent Intel chipsets on all the systems I tested.

Sounds bad.

BTW, when I took over from Vojtech, I looked at the suspend methods
for the printer and it seemed possible that they can only work
if the device is not open when suspend occurs. I was going to look
at that at the first opportunity.

So, I'd rather keep at least some kind of capability to suspend
printers, even if disabled by default. I thought Matthew's patch
was too harsh.

-- Pete
