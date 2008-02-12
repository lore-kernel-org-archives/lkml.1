Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbYBLQ06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbYBLQ06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760309AbYBLQ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:26:49 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53352 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762173AbYBLQ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:26:47 -0500
Message-Id: <20080212161340.200976067@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 12 Feb 2008 17:13:40 +0100
From: pierre.peiffer@bull.net
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24-mm1 0/8] (resend) IPC: code rewrite
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

	This is a resend of the first part of the patchset sent 2 weeks
ago. This is the part about the IPC which (again) proposes to consolidate
some part of the existing code.

	It does not change the behavior of the existing code, but
improves it in term of readability and maintainability as it consolidates it
a little. As there was no objection, I think you can include them in your 
-mm tree.

	The patchset applies on top of "2.6.24-mm1 + previous patches about
IPC" sent the last days (ie Nadia's patches + mine).

	For information, here is the global diffstat:

 ipc/msg.c  |  184 +++++++++++++++++++++++--------------------------------------
 ipc/sem.c  |  156 ++++++++++++++++++---------------------------------
 ipc/shm.c  |  176 ++++++++++++++++++----------------------------------------
 ipc/util.c |   64 +++++++++++++++++++++
 ipc/util.h |    3 
 5 files changed, 249 insertions(+), 334 deletions(-)


and the size of the resulting kernel:

- without the patchset:
$ size obj/vmlinux.ori
   text    data     bss     dec     hex filename
1903257  175820  122880 2201957  219965 obj/vmlinux.ori

- with the patchset:
$ size obj/vmlinux
   text    data     bss     dec     hex filename
1902917  175820  122880 2201617  219811 obj/vmlinux


-- 
Pierre Peiffer
