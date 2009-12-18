Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZLRPpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZLRPpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZLRPpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:45:00 -0500
Received: from home.kolivas.org ([59.167.196.135]:42479 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZLRPo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:44:59 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: BFS v0.312 configurable CPU scheduler for 2.6.32
Date: Sat, 19 Dec 2009 02:44:48 +1100
User-Agent: KMail/1.12.1 (Linux/2.6.32-ck1; KDE/4.3.2; x86_64; ; )
Cc: Willy Tarreau <w@1wt.eu>, Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200912111124.18118.kernel@kolivas.org> <20091212061447.GB2856@1wt.eu> <200912141516.54725.bzolnier@gmail.com>
In-Reply-To: <200912141516.54725.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912190244.48911.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested, BFS has been made a simple config option to enable/disable in 
kernel build. It is otherwise unchanged from .311. 

http://ck.kolivas.org/patches/bfs/2.6.32-sched-bfs-312.patch

A quick set of kernbench benchmarks on my quad core:

http://ck.kolivas.org/patches/bfs/kernbench2.6.32BFSvCFS.log

Note one person has had problems with preemptible tree based hierarchical rcu 
and bfs 311 using high amounts of CPU, the cause of which remains unknown at 
the moment. Probably safest to not use this combination for now.

Be nice,
enjoy!
-- 
-ck
