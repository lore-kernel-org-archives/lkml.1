Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYGXWGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYGXWGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYGXWGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:06:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:31680 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYGXWGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=oueRQbsiPnYG1uLQBTNtAcmcj3rMM3kWk8u0hvCuPH2GyymrNuDc+KBxSVrXdYLK8H
         6tKTSYuRngd0cKkg/lgs1Nj+xtD2GgB3SwSyfDSb0J4eoQa+JCwq3aQqRiiy41CYwfjm
         Dpl6hkgfv6Co9f/FXnZ+ekCbFU2f60KvNqpnM=
Subject: [patch, rfc: 0/2] sched, hotplug: cpu-hotplug vs. sched
	synchronization
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 00:05:56 +0200
Message-Id: <1216937156.5368.5.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


RFC, because I obviously might have missed something important and if
not, there can be better ways to address the issues (a few alternatives
included).

[1/2] safe use of rq->migration_thread and find_busiest_queue()

[2/2] ensure a task is on the valid cpu after set_cpus_allowed_ptr()


--Dmitry


