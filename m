Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXJHPRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXJHPRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXJHPRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:17:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:19634 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbXJHPRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=O3muUdm9lmG5fxiqKIUJIcnhhl9FBmAX8hB3SPoyaKsl7+aWBnJ+DnNRrUrWzW45BF65KKPjA0XsTqzU5lJhln39PrqTcqu75kkRnitW41ToHBO2LQOETjCwkDdPTUqC1hpyAb7YogJGFcd4IR83fA3pTwStOjC1jjet7js/l1g=
Message-ID: <90bced5d0710080817m7bb2a471tf533db0c9294fffb@mail.gmail.com>
Date: Mon, 8 Oct 2007 16:17:23 +0100
From: "Thierry Brown" <thierrybingo@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Linux Kernel 2.6 CPU scheduler
Cc: thierrybingo@googlemail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi-

I wish to be personally CC'ed the answers/comments posted to the list
in response to this post

I am new to Linux. i was reading about CPU scheduling in general and
that of Linux Kernel 2.6 in particular. I have three main questions:
1- Assume that the upper [higher priority] queue is empty and that the
lower queue contains a  thread Th2. The latter is assigned to the CPU
for a Quantum period of, say 30 ms. after 10 ms from its execution, a
new thread Th1 is admitted to the upper queue. as such Th2 is pre-
empted. Th1 is having the CPU.


At this context switch, will Th2 be switched to the expired array
queue? i guess no. Then when Th2 is assigned  to the CPU again, will
its assigned quantum reset to 30 ms, or instead to 30-10.


2- i can't see the need of the expired array queue. according to what
i have read, if any thread wants to use the cpu for a longer time than
their assigned quantum, it will be stopped and put in one of the
expired priority queues.


Is there any reference which details how the new assigned priority
queue is selected?
What this expired array queue is needed?
Why not assign the stopped thread to one of the active array queues
obviously after thread priority recalculation?


 By assigning a stopped thread Th to the expired queues array, we are
sure that the threads at the bottom of the actives queues will be
executed. however those threads could not be as important as Th which
has to wait until the active queues are run first before getting their
turn. probably , maintaining one array of active threads ONLY is
better? Am i missing something regarding the role of expired queues
array


3-is there any book / website  which details the practical kernel
algorithms supported with  code tracing or snippets


thank you for your time  :)
