Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYCJVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYCJVeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYCJVeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:34:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:29902 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYCJVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EqJPL1FIR4igmd2puvB061t//2WgzSm6ifG8yE2sPncV74SC8s+Fprd8Euuop8JQZPeBiSfMrBTM+p+eZlAxvyL5wqfCVCFzQ1GH+hVCnicP6X+MMmw22hfUqxwRDXwzwfeno+aAV+TOZ+5hKfIRxIBuQb6cuj55FAyuZOdxu0Y=
Message-ID: <86802c440803101434u1990b7f6t9106170330a85fd7@mail.gmail.com>
Date: Mon, 10 Mar 2008 14:34:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: 2.6.25-rc4: crash on boot when SMP enabled
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080310101654.GD9520@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306102927.GA4434@elf.ucw.cz> <20080306131547.GE21359@elte.hu>
	 <20080310101654.GD9520@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 3:16 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>
>  > > Quad-Core AMD Opteron...
>  > > Checking TSC Synchronization [CPU#0 -> CPU#3]: passed
>  > > BUG: unable to handle kernel paging request at 00...005958
>  > > IP: __alloc_pages+0x38
>  > > ...
>  > > Call trace:
>  > > kmem_getpages
>  > > cache_grow
>  > > ____cache_alloc_node
>  > > cpuup_callback
>  > > kmem_cache_alloc_node
>  > > cpuup_callback
>  > > notifier_call_chain
>  > > _cpu_up
>  >
>  > could you try latest x86.git:
>  >
>  >     http://people.redhat.com/mingo/x86.git/README
>  >
>  > does it fix it? Could be one of the numa fixes that are queued up.
>
>  I did an update to 2.6.25-rc4, and problem is now gone. Seems like
>  something really fixed it ;-).
>

please check if

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=7c9e92b6cdc9937eee53600e5d49a25e421463dd

fixed that.

YH
