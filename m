Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYKVAGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYKVAGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYKVAGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:06:37 -0500
Received: from smtp-out.google.com ([216.239.45.13]:24779 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYKVAGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:06:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=cX3JvN1IpQoey1jHzTZH7iNkctQ1ZobBidT7pcZCcD9sbFqkXrK2Lsi4PvoS4rPVW
	eGhij0gntt3Gw7/PJkV8g==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0811211520450.16413@chino.kir.corp.google.com>
References: <604427e00811201403k26e4bf93tdb2dee9506756a82@mail.gmail.com>
	 <alpine.DEB.2.00.0811211520450.16413@chino.kir.corp.google.com>
Date: Fri, 21 Nov 2008 16:06:33 -0800
Message-ID: <604427e00811211606v15e70bf8i3bde488f75dc08a3@mail.gmail.com>
Subject: Re: Make the get_user_pages interruptible
From: Ying Han <yinghan@google.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       Rohit Seth <rohitseth@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, i resent the patch with change in another thread.

thanks
--Ying

On Fri, Nov 21, 2008 at 3:24 PM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 20 Nov 2008, Ying Han wrote:
>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index b483f39..f2a5cac 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1795,6 +1795,7 @@ extern void flush_signals(struct task_struct *);
>>  extern void ignore_signals(struct task_struct *);
>>  extern void flush_signal_handlers(struct task_struct *, int force_default);
>>  extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t
>> +extern int sigkill_pending(struct task_struct *tsk);
>>
>>  static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask
>>  {
>
> I can't git apply this because it appears as though your email client has
> truncated long lines (see dequeue_signal above).
>
> Your headers look like you're using the gmail GUI to send patches, and
> that client has its own section in Documentation/email-clients.txt.  If
> the instructions don't happen to work for you, please fix that section
> once you've troubleshooted the problem.
>
