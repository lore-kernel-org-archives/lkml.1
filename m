Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495Ab0ANIRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab0ANIRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 03:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403Ab0ANIRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 03:17:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36737 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab0ANIRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:17:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v5] add MAP_UNLOCKED mmap flag
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20100114080117.GL18808@redhat.com>
References: <20100114162327.673E.A69D9226@jp.fujitsu.com> <20100114080117.GL18808@redhat.com>
Message-Id: <20100114170247.6747.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 17:17:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hmm..
> > Your answer didn't match I wanted.
> Then I don't get what you want.

I want to know the benefit of the patch for patch reviewing.


> > few additional questions.
> > 
> > - Why don't you change your application? It seems natural way than kernel change.
> There is no way to change my application and achieve what I've described
> in a multithreaded app.

Then, we don't recommend to use mlockall(). I don't hope to hear your conclusion,
it is not objectivization. I hope to hear why you reached such conclusion.


> > - Why do you want your virtual machine have mlockall? AFAIK, current majority
> >   virtual machine doesn't.
> It is absolutely irrelevant for that patch, but just because you ask I
> want to measure the cost of swapping out of a guest memory.

No. if you stop to use mlockall, the issue is vanished.


> > - If this feature added, average distro user can get any benefit?
> > 
> ?! Is this some kind of new measure? There are plenty of much more
> invasive features that don't bring benefits to an average distro user.
> This feature can bring benefit to embedded/RT developers.

I mean who get benifit?


> > I mean, many application developrs want to add their specific feature
> > into kernel. but if we allow it unlimitedly, major syscall become
> > the trushbox of pretty toy feature soon.
> > 
> And if application developer wants to extend kernel in a way that it
> will be possible to do something that was not possible before why is
> this a bad thing? I would agree with you if for my problem was userspace
> solution, but there is none. The mmap interface is asymmetric in regards
> to mlock currently. There is MAP_LOCKED, but no MAP_UNLOCKED. Why
> MAP_LOCKED is useful then?

Why? Because this is formal LKML reviewing process. I'm reviewing your
patch for YOU.

If there is no objective reason, I don't want to continue reviewing.



