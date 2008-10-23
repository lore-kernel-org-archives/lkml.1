Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYJWCuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYJWCuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYJWCuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:50:08 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:34466 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYJWCuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:50:07 -0400
Date: Wed, 22 Oct 2008 22:49:26 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 01/42] Staging: add pcc-acpi driver
In-reply-to: <20081022184808.GA24150@suse.de>
X-X-Sender: lenb@localhost.localdomain
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hiroshi Miura <miura@da-cha.org>,
       YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
       Harald Welte <laforge@gnumonks.org>, linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.1.10.0810222244130.3010@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081022172203.GA4000@kroah.com>
 <1224696563-5170-1-git-send-email-gregkh@suse.de>
 <alpine.LFD.1.10.0810221434070.3010@localhost.localdomain>
 <20081022184808.GA24150@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Oct 2008, Greg KH wrote:

> On Wed, Oct 22, 2008 at 02:37:18PM -0400, Len Brown wrote:
> > NAK.
> > this was already relplaced by the panasonic driver in the acpi tree.
> 
> Is this in 2.6.27, or was it a 2.6.28 addition?  For some reason, I had
> reports from openSUSE users that 2.6.27 still didn't work properly and
> needed this driver.
> 
> How about the new "pcc-acpi-cdrom" driver hack?  Hiroshi, is that needed
> still with the 2.6.27 kernel?

drivers/misc/panasonic-laptop.c is staged for 2.6.28:

http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=history;f=drivers/misc/panasonic-laptop.c;h=a2cb598d8ab54a98000d1f31f7c2407924399a5e;hb=test


> > Greg,
> > If it has the word "acpi" in it, please check with me before
> > putting something in the staging tree, for I'd prefer to
> > stage such things in the acpi tree.
> 
> Ok, I didn't know you wanted "uncleaned" drivers in your tree, I'll
> remember this for the future :)

AFAICK, the driver that was checked into staging tree
was based on an older version of the driver already staged
in the acpi tree.  I think that the staging tree
isn't helping us in this scenario.

thanks,
-Len


