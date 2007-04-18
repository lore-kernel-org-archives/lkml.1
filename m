Return-Path: <linux-kernel-owner+w=401wt.eu-S1422759AbXDRJy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422759AbXDRJy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422765AbXDRJy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:54:26 -0400
Received: from mail.parknet.jp ([210.171.160.80]:2717 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422759AbXDRJyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:54:25 -0400
X-AuthUser: hirofumi@parknet.jp
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Florin Iucha <florin@iucha.net>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
References: <20070416125905.GA2769@iucha.net>
	<1176736734.6761.45.camel@heimdal.trondhjem.org>
	<Pine.LNX.4.64.0704160904560.5473@woody.linux-foundation.org>
	<1176740307.6761.56.camel@heimdal.trondhjem.org>
	<1176741408.6761.62.camel@heimdal.trondhjem.org>
	<1176792399.3035.30.camel@twins> <20070416125905.GA2769@iucha.net>
	<1176792399.3035.30.camel@twins> <1176796503.3035.33.camel@twins>
	<87hcrfaqam.fsf@duaron.myhome.or.jp>
	<20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
	<20070417195823.943f9472.akpm@linux-foundation.org>
	<1176865565.6796.16.camel@heimdal.trondhjem.org>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 18 Apr 2007 18:54:13 +0900
In-Reply-To: <1176865565.6796.16.camel@heimdal.trondhjem.org> (Trond Myklebust's message of "Tue\, 17 Apr 2007 23\:06\:05 -0400")
Message-ID: <87bqhm9fei.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.98 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> writes:

> I was mainly interested in feedback from Peter, Florin and Ogawa-san to
> find out if this series fixes their problems. You were unfortunate
> enough to have been on earlier Ccs, so I didn't dare trim you off. :-)

Sorry. I'm trying to reproduce that, but unfortunately I can't
reproduce that on unpatched kernel for now.

FWIW, syslog is here.

Apr 17 03:54:55 duaron kernel: [drm] Initialized i915 1.6.0 20060119 on minor 0
Apr 17 03:58:31 duaron kernel: tun: Universal TUN/TAP device driver, 1.6
Apr 17 03:58:31 duaron kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Apr 17 03:58:44 duaron kernel: tun0: no IPv6 routers present
Apr 17 13:33:13 duaron kernel: NFS: desynchronized value of nfs_i.ncommit.
Apr 17 13:33:47 duaron last message repeated 16 times
Apr 17 13:34:49 duaron last message repeated 32 times
Apr 17 13:35:19 duaron last message repeated 7 times
Apr 17 13:39:39 duaron kernel: NFS: desynchronized value of nfs_i.ncommit.
Apr 17 13:40:39 duaron last message repeated 3 times
Apr 17 13:42:26 duaron kernel: NFS: desynchronized value of nfs_i.ncommit.
Apr 17 13:42:30 duaron last message repeated 3 times
Apr 18 00:58:22 duaron kernel: NFS: desynchronized value of nfs_i.ncommit.
Apr 18 00:59:09 duaron last message repeated 129 times
Apr 18 01:00:31 duaron last message repeated 24 times
Apr 18 01:02:16 duaron kernel: NFS: desynchronized value of nfs_i.ncommit.
Apr 18 01:03:25 duaron last message repeated 47 times
Apr 18 01:04:30 duaron last message repeated 16 times
Apr 18 01:05:31 duaron last message repeated 28 times
Apr 18 01:06:33 duaron last message repeated 32 times
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
