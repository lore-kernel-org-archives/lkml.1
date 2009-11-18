Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbZKRBGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbZKRBGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756575AbZKRBGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:06:32 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46238 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbZKRBGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:06:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U7G0t+sVKxpnCtRxNsmeW6P3R1AWdOLwqA/zy6rNFbakcE9If/ldAe7u7vuAomqT6A
         r6w7szHJKTuR9zqIbXm5+dy0kIhEIPhnsvWFLH8ClSbOztBbkJZXhSybaOi33poiTeka
         d+c+IcCOXclYvNInisD82NVlJ4BUbuU1akczg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 0/2] lockdep: Improvements for rwlocks dependency inversion detection
Date: Wed, 18 Nov 2009 02:06:36 +0100
Message-Id: <1258506398-5151-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is two patches to improve rwlocks dependency inversion
detection. If you ack these I can also add test suites for the
particular treated usecases.

Thanks,
	Frederic.

Frederic Weisbecker (2):
  lockdep: Include recursive read-locks dependencies in the tree
  lockdep: Don't only check recursive read locks once

 include/linux/lockdep.h |    1 +
 kernel/lockdep.c        |   88 ++++++++++++++++++++++++++--------------------
 2 files changed, 51 insertions(+), 38 deletions(-)

