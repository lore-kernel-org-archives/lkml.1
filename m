Return-Path: <linux-kernel-owner+w=401wt.eu-S968709AbXG3VeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968709AbXG3VeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967760AbXG3Vd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:33:59 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:57031 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967953AbXG3Vd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:33:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=p4zyImtm9GXVqfuQ+1YDqkQf4hUiyDZPRmA95dzWeyDRIT6TDxGzra6VldJYnUrG;
  h=Received:Message-ID:Reply-To:From:To:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <001201c7d2f1$942d5a60$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: <linux-kernel@vger.kernel.org>
Subject: schedular : No code : New interactive (ia) sched class : Part 1
Date: Mon, 30 Jul 2007 14:35:40 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec796905f369fa16897d6a859251aff30ecf350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.87.8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Comments for or against the SCHED_IA class in the generic
          Linux kernel source tree.
        - General comments::::
 
        With Ingo Molnar's 2.6.22 latest inclusions into the Linux
        source base, he has opened an opportunity to add additional
        task classes.
 
        This informal 1-pager is to try to identify whether their
        is support for the interactive (ia) task class. Posix explicitly
        states only three classes. However it states that
        implementations may define additional schedulars/classes.
 
          This 1-pager is to address the support for an additional
        schedular class SCHED_IA. 
        Currently interactive tasks are derived from
        SCHED_NORMAL based on sleep factors and generate bonuses/credits
        to alter their scheduling behaviour. However, this developer
        believes that other tasks with different behaviours exist that
        COULD also be classified as a ia task.
 
        This developers preconcieved belief is that the ia class could
        generally be supported with a minimal amount of effort, be a
        benefit to the Linux kernel, and to generally support the 
        following rules:
 
        * allow root / SUSER (Super USER) to determine that a task
          should be classified as a ia (interactive) task without 
          eviction based on scheduling behaviours,
 
        * allow SCHED_IA priorities be placed between the Real-time
          schedulars and SCHED_NORMAL/OTHER,
 
        * derive the interactive behaviour based on its nice value
          and/or  its initial combined priority,
 
        * TBD : identify whether the priority should be fixed or
          have limited variability within the ia interactive class,
 
        * user level command support to identify that a task is a
          interactive (ia) task,
 
        * etc (fork behaviours),
 
        Note: this 1-pager is not suggesting the removal or adjustment
              of interactive support within the SCHED_NORMAL/OTHER
              Linux, currently supported CFS environment.
 

        - Comments for or against the SCHED_IA class in the generic
          Linux kernel source tree.
        - General comments::::
 
        Mitchell Erblich
