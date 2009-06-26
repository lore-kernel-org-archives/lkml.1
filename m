Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZFZIy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZFZIy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZFZIyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:54:50 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36516 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbZFZIyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:54:49 -0400
Subject: Re: kmemleak suggestion (long message)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090626085056.GC3451@localdomain.by>
References: <20090625221816.GA3480@localdomain.by>
	 <20090626065923.GA14078@elte.hu>
	 <84144f020906260007u3e79086bv91900e487ba0fb50@mail.gmail.com>
	 <20090626081452.GB3451@localdomain.by>
	 <1246004270.27533.16.camel@penberg-laptop>
	 <20090626085056.GC3451@localdomain.by>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 26 Jun 2009 09:54:23 +0100
Message-Id: <1246006463.30717.12.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2009 08:54:24.0072 (UTC) FILETIME=[B4085C80:01C9F63B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 11:50 +0300, Sergey Senozhatsky wrote:
> On (06/26/09 11:17), Pekka Enberg wrote:
> > Well, the thing is, I am not sure it's needed if we implement Ingo's
> > suggestion. After all, syslog is no longer spammed very hard and you can
> > do all the filtering in userspace when you read /debug/mm/kmemleak file,
> > no?
> 
> Well, we just move 'spam' out of syslog. Not dealing with 'spam' itself.
> I'm not sure about 'filtering in userspace when you read'. Suppose I use
> 'tail -f /debug/mm/kmemleak'. How can I easy suppress printing of (for example):

I don't have a strong opinion on this patch at the moment, I'll have a
look later today.

> Or any report with tty_ldisc_try_get (ppp generates tons of them).

BTW, that's a real leak IMHO (posted a patch yesterday in reply to the
initial report to Alan Cox).

-- 
Catalin

