Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbZDPDKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbZDPDKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 23:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDPDKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 23:10:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:29406 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZDPDKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 23:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Afvo2uy6IE9nEBmI/lRSeGvWvujLQbPr4mw7objdPOO0drkvSwwQMOAZbvCgk3wbvG
         YscuGqZtavnqgeqvT6a8A1hh/0e7JlwPrLl6/PDlnmfe3Sy+BhJazySBqyYw2i1G6ZTE
         uK8wn/DOF8MaoHXxgzKML4iFfkZKfameMH5io=
MIME-Version: 1.0
In-Reply-To: <200904161130.28129.rusty@rustcorp.com.au>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> 
	<49E62BD5.6090508@zytor.com> <200904161130.28129.rusty@rustcorp.com.au>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Wed, 15 Apr 2009 20:10:16 -0700
X-Google-Sender-Auth: 63b159bb13062c78
Message-ID: <2c0942db0904152010y4fc4b08dyca50dac3965e5ffa@mail.gmail.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 7:00 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Anyone want to try to write a guide on writing good commit messages?

To me at least, this is no different than journalism (a commit message
is reporting on the facts, right?). So one can get some rough guidance
from thinking about who, what, where, when, why, how.


- Who is doing the work (from: lines)
- who will benefit from it. (ie, 'scope')

- What is the intended result? (feature? Bug-fix? Clean-up of the
foundations to prepare for future work?)
- What are you *doing*? (Not how -- which is the patch -- but what: a
human-understandable description of the patch.)

- Where is the feature or bug-fix needed or wanted? (Particular
laptops? hardware that is yet to hit the market? And -stable? -head?)

- When does the patch need to be applied? (This merge window, next
cycle, or as soon as possible for a root hole? After another set of
patches?)

- Why was it done *this* way, instead of another?
- Why does mainline want this? (For features. Bug fixes are self-explanatory.)

- how it was tested or validated (tested-by:, reviewed-by: tags).
- how it was implemented (which is satisfied by the patch itself)


Obviously not every patch needs all that crap. But every patch
*series* should probably have some thought put into all those, and the
ones that aren't obvious from the patch should be mentioned. The
trick, of course, is varying levels of 'obvious.' The measure of
'obvious' for journal articles is "someone who is versed in all the
necessary skills, but unfamiliar with the specifics of the topic."

Don't get me wrong, I don't want changelogs to be mini versions of war
and peace. But thinking about the above can put one in a better
context to then sit down and write a *nice* changelog.
