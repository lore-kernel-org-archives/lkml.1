Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZFZJL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZFZJL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbZFZJLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:11:45 -0400
Received: from mail.open.by ([193.232.92.17]:49623 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757784AbZFZJLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:11:44 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8838 [Jun 25 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Fri, 26 Jun 2009 12:13:17 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: kmemleak suggestion (long message)
Message-ID: <20090626091316.GD3451@localdomain.by>
References: <20090625221816.GA3480@localdomain.by>
 <20090626065923.GA14078@elte.hu>
 <84144f020906260007u3e79086bv91900e487ba0fb50@mail.gmail.com>
 <20090626081452.GB3451@localdomain.by>
 <1246004270.27533.16.camel@penberg-laptop>
 <20090626085056.GC3451@localdomain.by>
 <1246006463.30717.12.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246006463.30717.12.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/26/09 09:54), Catalin Marinas wrote:
> > Well, we just move 'spam' out of syslog. Not dealing with 'spam' itself.
> > I'm not sure about 'filtering in userspace when you read'. Suppose I use
> > 'tail -f /debug/mm/kmemleak'. How can I easy suppress printing of (for example):
> 
> I don't have a strong opinion on this patch at the moment, I'll have a
> look later today.
>
Well, take a look please. 
I find it (suggested mechanism) to be useful. 

> > Or any report with tty_ldisc_try_get (ppp generates tons of them).
> 
> BTW, that's a real leak IMHO (posted a patch yesterday in reply to the
> initial report to Alan Cox).
>
I'll try to find link to see it. Since tty_ldisc_try_get reports started
to 'annoy' me.
 
> -- 
> Catalin
> 

	Sergey
