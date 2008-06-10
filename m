Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYFJMeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYFJMeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYFJMdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:33:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYFJMdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:33:54 -0400
Message-Id: <20080610111259.766940257@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jun 2008 13:12:59 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH -rt 0/5] hotplug fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

the following patches enable me to 'almost' build a kernel while
hotplugging like crazy.

while :; do 
  echo 0 > /sys/devices/system/cpu/cpu1/online; 
  echo 1 > /sys/devices/system/cpu/cpu1/online; 
done

vs

make -j5

There still seems to be a bit of weirdness left, but I throught it time to post
these patches so that others can have a peek.

(patches against .24-rt)

