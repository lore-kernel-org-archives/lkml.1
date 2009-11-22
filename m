Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZKVMmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZKVMmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZKVMmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:42:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57959 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbZKVMmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:42:22 -0500
Date: Sun, 22 Nov 2009 13:42:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [bisected] pty performance problem
Message-ID: <20091122124209.GA30965@elte.hu>
References: <20091121222319.GA3905@swanrl.gmail.com>
 <20091122063926.GA18224@elte.hu>
 <20091122122312.71a343d9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122122312.71a343d9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sun, 22 Nov 2009 07:39:26 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > (Cc:-ed Alan and Linus - mail repeated below. eot.)
> 
> I saw it and replied already. The kernel now queues the work for the 
> pty as it does normal tty devices. If the CPU load is that low and 
> nothing else is happening it makes me wonder what the scheduler thinks 
> it is doing ?

Would be nice to see the testcase, but by the looks if it there appears 
to be a jiffy delay somewhere - not a scheduler delay. On an idle box 
the scheduler will run any runnable tasks, with no delay.

	Ingo
