Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbYCWOus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbYCWOus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 10:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbYCWOuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 10:50:39 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:46473 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbYCWOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 10:50:38 -0400
Date: Sun, 23 Mar 2008 20:20:29 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RT] [PATCH 0/3] Few cleanups and RT updates to sched_debug
Message-ID: <20080323145029.GB15554@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
Mail-Followup-To: Ankita Garg <ankita@in.ibm.com>,
	linux-rt-users <linux-rt-users@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Gregory Haskins <ghaskins@novell.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following 3 patches,

o Modify the names of several fields in the rt_rq, to be consistent
with the general naming convention. For eg, s/rt_nr_running/nr_running
in the rt_rq, 'rt' being implied by being associated with the rt_rq.

o Initialize rt.nr_running and rt.nr_uninterruptible fields explicitly.

o Update sched_debug to print values of the recently added fields to
rt_rq.

Some of these changes are not rt specific. But there are bits which are
missing from sched-devel latest, like rt_nr_uniterruptible, which is
added by preempt-realtime-sched.patch. I am not sure how to write
patches in this scenario. Pl do let me know if I need to generate patch
against the git tree instead, wherever possible.

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
