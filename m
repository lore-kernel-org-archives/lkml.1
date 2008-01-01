Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYAAQZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYAAQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYAAQZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:25:19 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56567 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYAAQZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:25:18 -0500
Date: Tue, 1 Jan 2008 17:25:16 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gene Heskett <gene.heskett@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: semi-regular plea for stable device mapping
In-Reply-To: <200801011054.40512.gene.heskett@gmail.com>
Message-ID: <Pine.LNX.4.64.0801011723140.14900@fbirervta.pbzchgretzou.qr>
References: <200801011054.40512.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 1 2008 10:54, Gene Heskett wrote:
>
>BUT!  This defeats a fix I've had in my modprobe.conf for over a year now that 
>gave the LVM stuff a stable major device # of 238, and now my LVM major is 
>back to whatever mood the kernel is in, in this particular bootup case to 
>#253.
>
>It may now be stable for a bit at that number because I see that pktcdvd has 
>been given a stable address of its own, apparently with a major of 10.  That 
>was the wedgie that fscked things up originally for me.  But what else lurks 
>in the deep end of this experimental pool, to play piranna with us again when 
>we least expect it?

Why exactly would you require a fixed major - not running udev or thelike?
Use the boot parameter, dm_mod.major=238.

>This drives tar up a wall because it uses this device number as part of the 
>file comparisons it does, and it thinks everything is therefore new and needs 
>a full level 0 backup.  This is not at all practical, and requires that 

I wonder how FreeBSD gets around this, because they've got dynamic numbers
everywhere.

