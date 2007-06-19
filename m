Return-Path: <linux-kernel-owner+w=401wt.eu-S1765362AbXFSAZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765362AbXFSAZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 20:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbXFSAY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 20:24:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:48102 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774AbXFSAY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 20:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EcWOip5fmWM+zpTLjg9wUmCvWR0VBLtS/5iScww+oVT3VG1gmVvEgpRpOLsh2oCuz3/T65XnRPFgeVzoe2lhpi9B7ov1NLnZ5FWt/TeMpAtmWu6VQ3VD7pJ7g8YDJUIHB/ehOemGz/NnnE4e2JFLA8t6rYicGghCP1BqENy1WPI=
Message-ID: <32209efe0706181724k26e0ee57laf9610b1834d4154@mail.gmail.com>
Date: Mon, 18 Jun 2007 17:24:55 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: How to improve the quality of the kernel?
Cc: "Martin Bligh" <mbligh@mbligh.org>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Oleg Verych" <olecom@flower.upol.cz>,
       "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	 <200706172349.08813.bzolnier@gmail.com>
	 <4675C083.6080409@s5r6.in-berlin.de>
	 <20070617220927.99ebc1ee.akpm@linux-foundation.org>
	 <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com>
	 <46770A22.4020007@mbligh.org>
	 <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>
	 <46771C5D.10809@mbligh.org>
	 <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 18 Jun 2007, Martin Bligh wrote:
> >
> > Sorry to be a wet blanket, but I've seen those sort of things
> > before, and they just don't seem to work, especially in the
> > environment we're in with such a massive diversity of hardware.
>
> I do agree. It _sounds_ like a great idea to try to control the flow of
> patches better, but in the end, it needs to also be easy and painfree to
> the people involved, and also make sure that any added workflow doesn't
> require even *more* load and expertise on the already often overworked
> maintainers..
>
> In many cases, I think it tends to *sound* great to try to avoid
> regressions in the first place - but it also sounds like one of those "I
> wish the world didn't work the way it did" kind of things. A worthy goal,
> but not necessarily one that is compatible with reality.
>
>                         Linus
>

Sure, simplicity is a key - but most of reporters on bugs are pretty
professional folks (or very well rounded amateurs :) We can try still
why not? the worst that can happen will be empty fields.

Maybe searching free text fields can then be implemented.  Then every
message exchange in bugzilla can be used for extracting such info -
questions about HW specifics are asked a lot, almost in every one.
It's a shame we cant' use this information. I was once searching for
"VIA" and got "zero bugs found", but in reality there are hundreds!
Probably something that makes sense to bring up with bugzilla project?

However, I've been working with other bugzillas (have to admit they
were mostly company/corporate), where this was a required field that
didn't seem to cause difficulties. I am planning to do some more
research and get some more ideas from other bugzillas. I suppose we
can have them discussed and revised sometime.

--Natalie
