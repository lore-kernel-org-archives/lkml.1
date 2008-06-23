Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbYFWXEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbYFWXEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYFWXEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:04:37 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:8666 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYFWXEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:04:36 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/3] RT: scheduler newidle enhancements
To: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-rt-users@vger.kernel.org, ghaskins@novell.com, dbahi@novell.com
Date: Mon, 23 Jun 2008 17:04:35 -0600
Message-ID: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Steven, Thomas,
  The following series applies to 25.4-rt6 and is "ready for inclusion" from
  my perspective.  However, due to their nature I am sure we will want to get
  some review feedback before being considered for acceptance.

  These patches are probably suitable for consideration for
  mainline/sched-devel as well, but PREEMPT_RT gains the biggest boost from
  them since it tends to context switch much more frequently than mainline.

  This series makes some adjustments to the way we do newidle balancing.
  These tweaks were discovered while doing some related scheduler R&D that is
  not quite ready for the light of day.  But these patches do offer a
  substantial boost (6-12%) in network performance.  They may help in other
  areas as well, but networking is where our focus remains currently.

  I think the patch 1/3 is a good one, but it requires careful review. Patch
  2/3 is based upon some work I had seen PeterZ submit, so its possible to
  just pull his work (if it hasnt been already) as opposed to this patch, if
  desired.  Lastly, Patch 3/3 is a bit controversial so I put it last for
  easier cherry picking of the first two.  It does help in our testing, but it
  will have to be reviewed carefully.

Comments/feedback/bugfixes more than welcome.

Thanks!
-Greg

  

