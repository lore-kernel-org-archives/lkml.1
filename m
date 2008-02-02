Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbYBBReX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbYBBReX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762761AbYBBReB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:34:01 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:57520 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760075AbYBBReA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:34:00 -0500
Date: Sat, 02 Feb 2008 18:31:48 +0100
Message-Id: <141350930@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Laurent.Vivier@bull.net, linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH] Allow NBD to be used locally
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+cBafW24iXOLdmvu5pBNHrGF+JJYIiPChOAdjz48Gfx4vwa
 e5bKXHYFzb+y7SY+8g/YfSNWdBfmussAITwh4NRxwl8qBAB+/k=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How will that work? Fuse makes up a filesystem - not helpful
> if you have a raw disk without a known fs to mount.

take zfs-fuse or ntfs-3g for example. 
you have a blockdevice or backing-file containing data structures and fuse makes those show up as a filesystem.
i think vmware-mount is not different here.

> This still does not account for compressed disk images, for example.
unfortunately, not




> 
> 
> On Feb 2 2008 15:40, devzero@web.de wrote:
> >
> >>In fact, VMware uses local nbd today for its vmware-loop helper
> >>utility, most likely because of the above-mentioned reasons. (Though
> >>it quite often hung last time I tried.)
> >
> >seems this will go away. recent vmware versions (e.g. server 2.0
> >beta) have a fuse based replacement for that.
> 
> How will that work? Fuse makes up a filesystem - not helpful
> if you have a raw disk without a known fs to mount.
> 
> >>So what we have is non-linearity -- LBA 22 comes after LBA 40 -- loop
> >>does not deal with that.
> >
> >maybe dm-loop does? http://sources.redhat.com/lvm2/wiki/DMLoop
> 
> This still does not account for compressed disk images, for example.
> 
> 


________________________________________________________
Bis 50 MB Dateianhänge? Kein Problem!
http://www.digitaledienste.web.de/freemail/club/lp/?lp=7

