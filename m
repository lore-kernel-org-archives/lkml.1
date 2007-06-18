Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbXFRAH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbXFRAH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbXFRAHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:07:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:40768 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbXFRAHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:07:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=PetjM3u+HQzvEcedXQKJ56d2Ezc1lI9WHzbWQsxflqekGhDN3sPDAF33nfZuOuxj5xNviDpwa3B8F4wC098Y4IDBE/D7lLuSR5mgfbXEB4ItlKRpoVGctVWjU2ZVTPhnkjxX/LpVUNx7BqBXPD6X1AmljAlgWbRYFnj5hLMAsyo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: How to improve the quality of the kernel?
Date: Mon, 18 Jun 2007 02:22:55 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <200706172349.08813.bzolnier@gmail.com> <4675C083.6080409@s5r6.in-berlin.de>
In-Reply-To: <4675C083.6080409@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706180222.55282.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007, Stefan Richter wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > despite the fact that audit takes
> > more time/knowledge then making the patch you will end up with zero credit
> > if patch turns out to be (luckily) correct.  Even if you find out issues
> > and report them you are still on mercy of author for being credited
> 
> If we introduce a "Reviewed-by" with reasonably clear semantics
> (different from Signed-off-by; e.g. the reviewer is not a middle-man in
> patch forwarding; the reviewer might have had remaining reservations...
> very similar to but not entirely the same as "Acked-by" as currently
> defined in -mm) --- and also make the already somewhat established
> "Tested-by" more official, --- then the maintainers could start to make
> it a habit to add Reviewed-by and Tested-by.
> 
> Plus, reviewers and testers could formally reply with Reviewed-by and
> Tested-by lines to patch postings and even could explicitly ask the
> maintainer to add these lines.

Sounds great.

> > so from personal POV you are much better to wait and fix issues after they
> > hit mainline kernel.  You have to choose between being a good citizen and
> > preventing kernel regressions or being bastard and getting the credit. ;)
> > 
> > If you happen to be maintainer of the affected code the choice is similar
> > with more pros for letting the patch in especially if you can't afford the
> > time to do audit (and by being maintainer you are guaranteed to be heavily
> > time constrained).
> 
> I don't think that a maintainer (who signs off on patches after all) can
> easily afford to take the "bastard approach".  I may be naive.

Well, I'm not doing it myself but I find it tempting... ;)

In case of being maintainer "bastard approach" is more about not discouraging
developers by holding patches for too long than about getting credit.

Bart
