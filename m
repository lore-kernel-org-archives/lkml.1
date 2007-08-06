Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbXHFUhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbXHFUhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932856AbXHFUhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:37:14 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:38751 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630AbXHFUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:37:11 -0400
Date: Mon, 6 Aug 2007 17:36:38 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: convert mm_context_t semaphore to a mutex
Message-ID: <20070806173638.76235263@localhost>
In-Reply-To: <p73vebslar5.fsf@bingen.suse.de>
References: <20070803105540.4f85ae09@localhost>
	<20070806074608.GA12415@elte.hu>
	<20070806103615.4be4670f@localhost>
	<p73vebslar5.fsf@bingen.suse.de>
Organization: Mandriva
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em 06 Aug 2007 21:32:29 +0200
Andi Kleen <andi@firstfloor.org> escreveu:

| "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> writes:
| > 
| >  I'll manage to test it then. Do you have a test-case or has any
| > suggestion?
| 
| LTP has some simple test cases for modify_ldt

 I've just ran them from a LTP suite from 2007/04/30:

"""
/usr/lib/ltp/testcases/kernel/syscalls/modify_ldt/ ./modify_ldt01 
modify_ldt01    0  INFO  :  Enter block 1
modify_ldt01    0  INFO  :  block 1 PASSED
modify_ldt01    0  INFO  :  Exit block 1
modify_ldt01    0  INFO  :  Enter block 2
modify_ldt01    0  INFO  :  block 2 PASSED
modify_ldt01    0  INFO  :  Exit block 2
modify_ldt01    0  INFO  :  block 3 PASSED
modify_ldt01    0  INFO  :  Exit block 3
"""

"""
/usr/lib/ltp/testcases/kernel/syscalls/modify_ldt/ ./modify_ldt02
modify_ldt02    0  INFO  :  Enter block 1
modify_ldt02    0  INFO  :  block 1 PASSED
modify_ldt02    0  INFO  :  Exit block 1
modify_ldt02    0  INFO  :  Enter block 2
modify_ldt02    0  INFO  :  received signal: 11
modify_ldt02    0  INFO  :  block 2 PASSED
/usr/lib/ltp/testcases/kernel/syscalls/modify_ldt/ 
"""

 All passed it seems.

 Btw, I've send the same patch for x86_64 to you too.

-- 
Luiz Fernando N. Capitulino
