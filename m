Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYJPSRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYJPSRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbYJPSQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:16:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:63282 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925AbYJPSQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=ZKR5NDPRmkbTmbEdQCx9Qltr8FbTW+i39Z/g8urH7Iie8dbmqHfpO1BFks4Jod/FeK
         Of8T7pS23T/l3fYjkQdfKPEmpGI+FOfKb+0Dp0vMl7Hw4fIFT0U+IEbbnGSccFWeqc37
         wETYfuVahnXRMJ//4RzWPK7fz/EgLywtbGlv4=
Date: Thu, 16 Oct 2008 14:14:52 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
Message-ID: <20081016181452.GA29739@yoda.jdub.homelinux.org>
References: <20080906050602.409299112@goodmis.org> <20080906120346.GA30964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906120346.GA30964@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 02:03:47PM +0200, Ingo Molnar wrote:
>
>* Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> I spent the day chasing a bug that would hang PPC on boot up when 
>> ftrace is configured in. I found that it was simply a stupid bug I did 
>> to handle the non MCOUNT_RECORD case. Since I was testing only on x86, 
>> and the MCOUNT_RECORD is automatically set for dynamic ftrace if it is 
>> available, I did not test the case where MCOUNT_RECORD was not set.
>> 
>> I have not finished porting MCOUNT_RECORD to PPC, but have found that 
>> it has caused some issues for archs that do not support it yet.
>> 
>> This patch series handles these cases.
>
>applied to tip/tracing/ftrace, thanks Steve.

Are these two merged yet?  I just spent the better part of the morning
trying to figure out why various Fedora kernels based on 2.6.27-rcX and
2.6.27 final hung on my G5 and finally got one booting with FTRACE
disabled.

josh
