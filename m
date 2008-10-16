Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYJPShH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYJPShH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYJPSg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:36:56 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:5607 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYJPSgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=g2whe1XV/YadllPjGOLkMWDBAU6V2GRyWL6l0s1bB3pwelxHGX3ZqDMdMKC9QJbQW/
         vZ7dXGGP2vdfaJ7/qMTr+wjOI8X3SsSINMSYzlfvcS7U/wUkmpqVQaPV6t0jGsE7rj3A
         Bl38N9Qv5T1nulCZKZec1lvIL/hfRoczGZkl0=
Date: Thu, 16 Oct 2008 14:35:29 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
Message-ID: <20081016183529.GB29739@yoda.jdub.homelinux.org>
References: <20080906050602.409299112@goodmis.org> <20080906120346.GA30964@elte.hu> <20081016181452.GA29739@yoda.jdub.homelinux.org> <alpine.DEB.1.10.0810161421530.11042@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810161421530.11042@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 02:22:48PM -0400, Steven Rostedt wrote:
>
>On Thu, 16 Oct 2008, Josh Boyer wrote:
>
>> On Sat, Sep 06, 2008 at 02:03:47PM +0200, Ingo Molnar wrote:
>> >
>> >* Steven Rostedt <rostedt@goodmis.org> wrote:
>> >
>> >> I spent the day chasing a bug that would hang PPC on boot up when 
>> >> ftrace is configured in. I found that it was simply a stupid bug I did 
>> >> to handle the non MCOUNT_RECORD case. Since I was testing only on x86, 
>> >> and the MCOUNT_RECORD is automatically set for dynamic ftrace if it is 
>> >> available, I did not test the case where MCOUNT_RECORD was not set.
>> >> 
>> >> I have not finished porting MCOUNT_RECORD to PPC, but have found that 
>> >> it has caused some issues for archs that do not support it yet.
>> >> 
>> >> This patch series handles these cases.
>> >
>> >applied to tip/tracing/ftrace, thanks Steve.
>> 
>> Are these two merged yet?  I just spent the better part of the morning
>> trying to figure out why various Fedora kernels based on 2.6.27-rcX and
>> 2.6.27 final hung on my G5 and finally got one booting with FTRACE
>> disabled.
>
>My powerbook does not boot with ftrace enabled. I'm currently debugging 
>it. When I get it working, you'll see patches.

Well, that's why I asked.  You sent 2 patches out over a month ago that
don't appear to have shown up in any Linus or PowerPC tree.

>They will be to linux-tip though, and not for the current mainline (unless 
>the code in linux-tip gets merged).

If linux-tip is some x86 topic branch, I think that's the wrong place for
fixes that are needed on non-x86 arches.

josh
