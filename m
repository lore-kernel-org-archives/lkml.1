Return-Path: <linux-kernel-owner+w=401wt.eu-S936113AbYBCGCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936113AbYBCGCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYBCGCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:02:20 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:41496 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYBCGCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:02:19 -0500
Message-ID: <f73f7ab80802022202s2c695a8fjea20e5092e9c5dcc@mail.gmail.com>
Date: Sun, 3 Feb 2008 01:02:18 -0500
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] Allow NBD to be used locally
Cc: devzero@web.de, Laurent.Vivier@bull.net, linux-kernel@vger.kernel.org,
       pavel@ucw.cz
In-Reply-To: <Pine.LNX.4.64.0802021834380.18790@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <141350930@web.de>
	 <Pine.LNX.4.64.0802021834380.18790@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, only hit "Reply" on the first email, sorry Jan.

On Feb 2, 2008 7:54 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> On Feb 2 2008 18:31, devzero@web.de wrote:
> >
> >> How will that work? Fuse makes up a filesystem - not helpful
> >> if you have a raw disk without a known fs to mount.
> >
> >take zfs-fuse or ntfs-3g for example.
> >you have a blockdevice or backing-file containing data structures and fuse makes those show up as a filesystem.
> >i think vmware-mount is not different here.
>
> vmware-mount IS different, it provides the _block_ device,
> which is then mounted through the usual mount(2) mechanism
> (if there is a filesystem driver for it).

As far as I can tell, vmware-mount should be re-implemented as a
little perl script around "dmsetup" and/or "losetup", possibly with
"dm-userspace" patched into the kernel to allow you to handle
non-mapped blocks in your userspace daemon when somebody tries to
access them.  If you don't need that ability then straight dm-loop and
dm-linear will work.

Cheers,
Kyle Moffett
