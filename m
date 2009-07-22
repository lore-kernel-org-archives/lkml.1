Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZGVM6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZGVM6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZGVM6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:58:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:14619 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZGVM6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eEujao2ErScwgwFt7SGcxmVGxAbc6i8iQeHds+JtMEf/TVgfL76ltM22HiZZiF9k3g
         ShNcTXFuNFl8qBHJPD+ga15IkJnGHnGT63a4ppDkHP8FrXYu9g/xyK8gxwb5fdSaAy4H
         lN3R3LbZWwTzzXkLNPjo2Kt1/kJDjMGL7bkLg=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [tip:core/locking 0/3] lockdep:bfs optimization
Date: Wed, 22 Jul 2009 20:58:30 +0800
Message-Id: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This series does the BFS optimizations:

	.reintroduce DaveM's generation id to bfs to make it faster
	.make bfs preallocated "stack" as per cpu variable
	.add likely/unlikely annotations to BFS core routine

and the patches are based on Peter's patches against tip:core/locking:

	http://marc.info/?l=linux-kernel&m=124793787804558&w=2
	http://marc.info/?l=linux-kernel&m=124793787804556&w=2

Also, the patches have passed lockdep's selftest.

include/linux/lockdep.h |    1 +
kernel/lockdep.c        |   26 ++++++++++++++------------
2 files changed, 15 insertions(+), 12 deletions(-)


Thanks,
Lei Ming
