Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0CEHM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:12:27 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:62104 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0CEHM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=q32BMe1vORodB1PaDoulSg98S5Mgmm9PXu59nM+upzu9X4F0PBZr7S9WGYOX+/SWxO
         oA3ZOQeDyu//YWA1iYQ5mWkRRK1Z3xtTUu15CpmZyAZfhXxIt/hc4t8/3SAaohZT17HH
         fjQI05oL11+bPCpRCNSxR5dJS2dWEaQ1wxqWg=
MIME-Version: 1.0
Date: Fri, 5 Mar 2010 15:12:25 +0800
Message-ID: <c6ed1ac51003042312k103aafddpda82d2d64bd5f73d@mail.gmail.com>
Subject: sched_fair: vruntime and min_vruntime will be overflow?
From: figo zhang <figo1802@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

when enqueue or dequeue the task, the se->vruntime and cfs_rq->min_vruntime will
increased, i want to know it is will be overflow in future time?

Best,
Figo.zhang
