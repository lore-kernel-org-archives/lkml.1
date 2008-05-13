Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbYEMIyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbYEMIyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbYEMIxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:53:54 -0400
Received: from mail.numalliance.com ([213.41.233.134]:57082 "EHLO
	mail.numalliance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbYEMIxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:53:53 -0400
Message-ID: <4829566B.7090804@free.fr>
Date: Tue, 13 May 2008 10:50:51 +0200
From: =?ISO-8859-1?Q?St=E9phane_ANCELOT?= <sancelot@free.fr>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: detecting kernel mem leak
References: <1209462094.4816ed4e93977@imp.free.fr> <84144f020804290546h666983aci77fbb08eb507e777@mail.gmail.com> <Pine.LNX.4.64.0804290956360.10847@schroedinger.engr.sgi.com> <4821C526.8030901@free.fr> <Pine.LNX.4.64.0805071020210.3173@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805071020210.3173@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I kept my kernel running with few applications for 5 days , doing
nothing more than backing up few kb of data on disk and refresh few X apps.

Ater five days the global memory available go down from 24Mb to 8Mb ...

The are some signifiant changes in slabinfo but now, I do not know where
to search ?

active_jobs :
proc_inode_cache : 150 -> 299
radix_tree_node : 807 -> 870
dentry: 4092 ->4249
buffer_head: 1138 -> 4824
pid_1: 64 -> 76
size-64 : 885 -> 944

memory BEFORE          AFTER :

MemFree:          24324 kB.................8692Kb
Buffers:              3956   kB...............18740Kb
Cached:             34080  kB................34452Kb
Active:             131176 kB................147592Kb
Inactive:             26708 kB..................25440Kb

Slab:             4692 kB........4952kB

SReclaimable:     1480 kB ............. 1744kb
SUnreclaim:        3212 kB...............3208kb



in the ps tree only Xorg SHR memory growed from 5592 to 5612


