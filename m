Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbXHCNFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbXHCNFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763059AbXHCNBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:01:00 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:55916 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762896AbXHCNA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:00:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qLNUtojxVtbYzxCUSvkU2ppKn9JxqkFO+qW63fqcCvlycKZ6mnN0F4psDCMIlYJicPOR/lCHBHilQy0VO+dwxJIJ+c9xRhFIEjjXYhY5Dlj88CXUSn7ph56IkVlDp/OuhO4liA6cSlEdwT/obVG7boyy0Ffv2uvZm4/wItpRNQY=
Message-ID: <f24d23310708030600o66cbf862y39197bf2ca23d9ab@mail.gmail.com>
Date: Fri, 3 Aug 2007 18:30:56 +0530
From: "debian developer" <debiandev@gmail.com>
To: "T. J. Brumfield" <enderandrew@gmail.com>
Subject: Re: Scheduler Situation
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/3/07, T. J. Brumfield <enderandrew@gmail.com> wrote:
> First off, I am an avid reader of the LKML but I'm not a developer.
> Admittedly I am a piss-poor C developer who likes to poke around the
> code, play with patches and attempt to learn, but in reality at best I
> pretend I understand it, and I don't really.  I fully defer to the
> technical knowledge of far greater minds on this list.  Even having a
> basic understanding of C and looking at the code, I still don't
> understand basic kernel operations like memory management or CPU
> scheduling well enough to see in code what works best.
>
> What I can say, is that someone who has had years of project
> management experience, it is painfully obvious here that there are
> events here in personal issues which should be easy to spot and
> rectify.
>
> I, like many people, had been using Con's patches for years and were
> greatly pleased by them.  I've experimented with a variety of kernel
> flavor and patches, often woefully trying to amass my own collection
> of custom patches and often breaking things while trying to integrate
> too many patches at once that don't patch nicely with one another.
> And when I've had questions, I often read through Con's mailing list
> archives from his site.
>
> It would appear he spent 4 years working on his patch-set, primarily
> based around his version of a scheduler.  And in reading the LKML it
> seems that aspects of his patch-set he pushed for mainline inclusion.
> He was shot down saying that his ideas were flat-out wrong, and still
> he worked for years to improve his work.  He answered questions, fixed
> bugs, and made himself very available.
>
> It may very well be that CFS is a better scheduler than SD.  Ingo is a
> very respected coder, and from even Con's mouth it seems that CFS is
> pretty simple in its execution.  Ingo seems to suggest that since he
> posted his code so quickly after he wrote it, that he didn't do
> anything wrong.
>
> Linus, a man I greatly admire and respect, especially for his
> blunt/terse statements, also seems to suggest that no one has wronged
> Con here.  However in insisting that the decision was based on Con's
> inability to support his code, I can fully understand why Con would
> leave kernel development permanently.
>
> The simple truth is that Con poured years into a project despite being
> rebuffed and told he was wrong.  The moment that people change their
> minds and realize that his concepts have merit, no one apologizes for
> all the past criticism.  Ingo did very much credit Con for
> inspiration, but I can't see how this decision was anything but
> political.  Linus said it himself, that he trusts Ingo to stand behind
> the code, and he didn't trust Con to do the same.
>
> I am reticent to accuse anyone of dishonesty, but that statement just
> doesn't seem to add up.  And even if that is the way Linus truly felt,
> it doesn't seem fair given how well Con had supported his code and his
> users.  Regardless for a man who claims to not make political
> decisions on code, that is exactly how he operated here.  He chose the
> person over the code.  From his own mouth, it seemed he remains very
> put off by earlier comments from the "Con camp" that perhaps there
> should be separation between the server and desktop kernels.
>
> And while Linus is no-doubt correct that such a separation should not
> occur, I never really saw Con push for such a thing.  I know I don't
> fully understand the code, but it does seem to make sense to an idiot
> like me however that with all the other kernel options to customize
> your build for your needs, it isn't beyond reason to go with a
> plugsched type solution.  The kernel is already immensely modular, no
> doubt the most modular piece of code on the planet.
>
> It works amazingly well in small embedded devices to large
> multi-processor servers across multiple architectures and processor
> types.  The reason I'm posting on an issue I'm sure that many people
> are already sick of, is that I'm sure many people would like to see
> two things happen.
>
> 1 - Can someone please explain why the kernel can be modular in every
> other aspect, including offering a choice of IO schedulers, but not
> kernel schedulers?

Good question. has been answered in other threads. Linus does'nt like
having separate kernel schedulers.
