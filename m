Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYG3Olg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYG3Olg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759936AbYG3OlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:41:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:5126 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbYG3OlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:41:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oZs4FcVJALI2tzsgQBr7+zTvYREz0TDHDqm1QMV4dwqXxZOYEjqfVfSjoI7S3f3402
         C+VHipp3reuot1oEo1Gl5LChjZa4+UXOc+tAPGZYpQ2JFHsLkait9j8W4Bi/iab9mSsX
         UVNtL5R3fw9FEz0rcCZBBmKe3ozehhIf/TVYk=
Message-ID: <48f7fe350807300741t4f8dff41ide2318c8464d31c8@mail.gmail.com>
Date: Wed, 30 Jul 2008 10:41:09 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.26-rt1
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Clark Williams" <williams@redhat.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Carsten Emde" <ce@ceag.ch>
In-Reply-To: <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0807271719130.574@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been running this for a few days now. If I remove all debug
options from kconfig my dmesg is clean. Every thing seems pretty
stable but I have had a few random hardlocks that I can really narrow
down to anything.

-Ryan

On Tue, Jul 29, 2008 at 6:21 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> We are pleased to announce the 2.6.26-rt1 tree, which can be
> downloaded from the location:
>
>   http://rt.et.redhat.com/download/
>
> Information on the RT patch can be found at:
>
>   http://rt.wiki.kernel.org/index.php/Main_Page
>
> The merge was mostly done by Steven Rostedt, I just fixed it up, added
> the fixes from .24-rt17 and tested it on x86 32/64bit.
>
> This is the first cut of .26-rt, so don't expect it to be perfect.
>
> I run out of time, so I dropped Peter's cpu-hotplug patches
> completely. The hotplug and rcupreempt code has changed radically, so
> we need to redo that lot. Peter, Paul can you please look into that ?
>
> I tried to address the non-x86 issues as far as I could, but I had no
> chance to compile test them. So please check the wreckage.
>
> to build a 2.6.26-rt1 tree, the following patches should be applied:
>
>   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
>   http://rt.et.redhat.com/download/patch-2.6.26-rt1.bz2
>
> And like always, Steven's RT version of Matt Mackall's ketchup will get this
> for you nicely:
>
>  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3
>
> As usual the broken out patches are also available.
>
> I'm going on vacation tomorrow so feel free to blame/curse/flame me,
> but please work with Steven to get it into shape.
>
> Thanks,
>
>        tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
