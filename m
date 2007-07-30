Return-Path: <linux-kernel-owner+w=401wt.eu-S938986AbXG3TkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938986AbXG3TkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763361AbXG3Tj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:39:58 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:49069 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762681AbXG3Tj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:39:57 -0400
To: a1426z@gawab.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       xfs@oss.sgi.com, linux-raid@vger.kernel.org
In-reply-to: <200707302207.02672.a1426z@gawab.com> (message from Al Boldi on
	Mon, 30 Jul 2007 22:07:02 +0300)
Subject: Re: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on software raid 5
References: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan> <200707302207.02672.a1426z@gawab.com>
Message-Id: <E1IFb5f-00006O-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Jul 2007 21:39:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Extrapolating these %cpu number makes ZFS the fastest.
> 
> Are you sure these numbers are correct?

Note, that %cpu numbers for fuse filesystems are inherently skewed,
because the CPU usage of the filesystem process itself is not taken
into account.

So the numbers are not all that good, but according to the zfs-fuse
author it hasn't been optimized yet, so they may improve.

Miklos
