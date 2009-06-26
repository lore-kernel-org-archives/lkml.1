Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZFZHrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZFZHrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZFZHrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:47:16 -0400
Received: from mail.open.by ([193.232.92.17]:64014 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbZFZHrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:47:15 -0400
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
Date: Fri, 26 Jun 2009 10:48:48 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Ingo Molnar <mingo@elte.hu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: kmemleak suggestion (long message)
Message-ID: <20090626074847.GA3451@localdomain.by>
References: <20090625221816.GA3480@localdomain.by>
 <20090626065923.GA14078@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626065923.GA14078@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/26/09 08:59), Ingo Molnar wrote:
> Date: Fri, 26 Jun 2009 08:59:23 +0200
> From: Ingo Molnar <mingo@elte.hu>
> To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> Cc: Catalin Marinas <catalin.marinas@arm.com>,
> 	Pekka Enberg <penberg@cs.helsinki.fi>,
> 	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
> 	Andrew Morton <akpm@linux-foundation.org>,
> 	linux-kernel@vger.kernel.org, linux-mm@kvack.org
> Subject: Re: kmemleak suggestion (long message)
> User-Agent: Mutt/1.5.18 (2008-05-17)
> 
> 
> * Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:
> 
> > Hello.
> > 
> > Currently kmemleak prints info about all objects. I guess 
> > sometimes kmemleak gives you more than you actually need.
> 
> It prints _a lot_ of info and spams the syslog. I lost crash info a 
> few days ago due to that: by the time i inspected a crashed machine 
> the tons of kmemleak output scrolled out the crash from the dmesg 
> buffer.
> 
> This is not acceptable.
> 
Agreed.

> Instead it should perhaps print _at most_ a single line every few 
> minutes, printing a summary about _how many_ leaked entries it 
> suspects, and should offer a /debug/mm/kmemleak style of file where 
> the entries can be read out from.
> 
> Ok?
> 
> 	Ingo
> 
Agreed.

	Sergey
