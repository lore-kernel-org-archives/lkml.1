Return-Path: <linux-kernel-owner+w=401wt.eu-S932688AbZLEAqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbZLEAqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932525AbZLEAqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:46:47 -0500
Received: from mail2.racsa.co.cr ([196.40.31.26]:37982 "EHLO
	barracuda5.racsa.co.cr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbZLEAqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:46:46 -0500
X-ASG-Debug-ID: 1259974018-042802950000-xx1T2L
X-Barracuda-URL: http://172.16.1.14:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: osobosque@racsa.co.cr
Date: Fri, 04 Dec 2009 18:46:42 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
Subject: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
In-reply-to: <alpine.LFD.2.00.0911302307440.24119@localhost.localdomain>
Message-id: <alpine.LNX.2.00.0912040841010.743@bruno>
References: <alpine.LNX.2.00.0911291057100.2912@bruno>
 <4B143AE8.5090608@us.ibm.com>
 <alpine.LFD.2.00.0911302307440.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Barracuda-Connect: UNKNOWN[172.16.7.12]
X-Barracuda-Start-Time: 1259974018
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at racsa.co.cr
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=4.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=6.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.16295
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello:

Just installed 2.6.32 and the problem is still there.  The value returned
for curval in futex_init is still the same 0xf0006aa0, and thus as before
futex_cmpxchg_enabled is not set, thus causing many kernel futex syscalls to
return -ENOSYS incorrectly, the proximate cause of the glibc test failures.

Regards,

Joseph

