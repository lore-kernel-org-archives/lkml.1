Return-Path: <linux-kernel-owner+w=401wt.eu-S1765359AbYBBQ5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765359AbYBBQ5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYBBQ5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:57:47 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50023 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbYBBQ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:57:46 -0500
Date: Sat, 2 Feb 2008 17:57:45 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: devzero@web.de
cc: linux-kernel@vger.kernel.org, Laurent.Vivier@bull.net, pavel@ucw.cz
Subject: Re: [PATCH] Allow NBD to be used locally
In-Reply-To: <141208903@web.de>
Message-ID: <Pine.LNX.4.64.0802021755140.18790@fbirervta.pbzchgretzou.qr>
References: <141208903@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 2 2008 15:40, devzero@web.de wrote:
>
>>In fact, VMware uses local nbd today for its vmware-loop helper
>>utility, most likely because of the above-mentioned reasons. (Though
>>it quite often hung last time I tried.)
>
>seems this will go away. recent vmware versions (e.g. server 2.0
>beta) have a fuse based replacement for that.

How will that work? Fuse makes up a filesystem - not helpful
if you have a raw disk without a known fs to mount.

>>So what we have is non-linearity -- LBA 22 comes after LBA 40 -- loop
>>does not deal with that.
>
>maybe dm-loop does? http://sources.redhat.com/lvm2/wiki/DMLoop

This still does not account for compressed disk images, for example.

