Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZDGK2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZDGK2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZDGK2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:28:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:34372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbZDGK17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:27:59 -0400
Subject: [RFC] Static/Runtime CPU/IO bound scheduling polices based on
 CPU(s) to support complete spectrum of tasks
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 15:55:31 +0530
Message-Id: <1239099931.4773.25.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am planning to prepare the followings:

1. This will be also eligible for UP but more useful for SMPs having
multiple CPUs.

2. Here we can support static/runtime scheduling polices for each CPU
core.

3. Static scheduling polices can be allocated by using command
parameter.

4. In runtime scheduling polices where scheduling polices can be changed
at runtime.

5. Runtime scheduling will be further divided into User defined, Smart
scheduling (automatically by system) and Hybrid scheduling.

6. These scheduling policies can be CPU bound and/or IO bound or others.

7. These scheduling policies can be task based or can be group based say
firefox tasks or multimedia group.

8. By this way we can support complete spectrum of tasks say Non
real-time (NRT), Soft real-time(SRT) and Hard real-time (HRT) tasks.
Like NRT: CPU0, CPU1 and SRT: CPU2 and HRT: CPU3

9. Users can further divide the tasks as NRT, SRT and HRT and can also
change the priorities of each task or group of tasks if they want.

10. In User defined scheduling polices, user can set scheduling polices
for each CPU core at runtime and check what is the performance
(efficiency) of the system.

11. Users can also allocate the scheduling polices per CPU core based on
their requirement and can change it any time.

12. Users can specify which CPUs will work as NRT, SRT and HRT.

13. Users can specify scheduling policies for NRT, SRT and HRT.

14. User will check the performance (efficiency) of the system and also
take suggestion from system that which policy will be better for them.

15. In Smart scheduling policies, system will change the scheduling
polices based on performance (efficiency) of the system to get the
maximum efficiency.

16. Smart scheduling will decide which CPU will work as NRT, SRT and
HRT.

17. Smart scheduling will decide scheduling policies for NRT, SRT and
HRT.

18. In hybrid scheduling where both User defined and Smart scheduling
will work together.

19. In hybrid scheduling, user will define which CPUs will work as User
defined and which CPU will work as Smart scheduling.

20. We can also see the status of the overall system performance and
also based on HRT, SRT and NRT.

Thanks,
--
JSR

