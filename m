Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbXFVHgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbXFVHgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbXFVHgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:36:13 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:15114 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXFVHgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GzYpIgA8mIwqh7TyEiur09v5TNOxQGuXNli1faF2Kue4vIUTT7ONGKn+p8cRGh93i9jtjGae+QQJciSO2wRw5p5aN25Tc3cyM+F8meFsU+LZSbdAIns1Ovb4eBbP0Cc07ieg01r65u57V7TEhzyMgi6UMp7FKoapj4k7dBumeik=
Message-ID: <7b9198260706220036u627f7538o51fa4f5d2be87e69@mail.gmail.com>
Date: Fri, 22 Jun 2007 08:36:08 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v17
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20070614224908.GA9412@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070614224908.GA9412@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> i'm pleased to announce release -v17 of the CFS scheduler patchset.
>
> The rolled-up CFS patch against v2.6.22-rc4, v2.6.22-rc4-mm2, v2.6.21.5
> or v2.6.20.13 can be downloaded from the usual place:
>
>    http://people.redhat.com/mingo/cfs-scheduler/
>
> -v17 includes a bigger change: the CFS-core changes in preparation of
> the group-scheduling feature, written Srivatsa Vaddagiri. Dmitry
> Adamushko provided cleanups and further generalizations to this code and
> the modularization of CFS has been further enhanced as a result. To
> users, these changes are mostly invisible.
>
> Changes since -v16:
>
>  - lots of core updates to support group scheduling, and related
>    cleanups. (Srivatsa Vaddagiri, Dmitry Adamushko)
>
>  - tuned the runtime-limit up a bit, based on relentless testing done by
>    Tobias Gerschner.
>
>  - the new, precise load-calculation method for SMP balancing has been
>    further enhanced, and is now active by default. (Dmitry Adamushko)
>
>  - fix SCHED_IDLEPRIO support (based on feedback from Thomas Sattler)
>
>  - further updates to /proc/sched_debug and /proc/PID/sched
>
>  - more cleanups
>
> As usual, any sort of feedback, bugreport, fix and suggestion is more
> than welcome!
>
>         Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Hi everyone,

I'm just writing to say how impressed I am with the new CFS scheduler.
 I've been following it's development from the first patch, right up
to now (running on the latest vanilla kernel I could!) and I can
honestly say I've never had such a responsive experience.

I'm currently writing a major patch to the ext2 file-system driver, as
part of a University project - it involves a lot of kernel rebuilds as
I'm testing the patch in UML.  I've had a couple of kernel compiles
happening simultaneously (on my moderate single CPU PC), and tried out
a few make -j12's, and I'm amazed at the difference the new scheduler
makes.

I've got quite a few instances of Firefox (whoops, Iceweasel) open,
I'm listening to music and theres a few other apps running (like KNode
the newsreader) and the interactivity response has been excellent.

In conclusion, well done to the scheduler people and I look forward to
seeing this go to mainline.

(If there's anything I can do to help, I'd love to throw a few patches
at the mailing list ;)

-- 
Regards,
Tom Spink
University of Edinburgh
