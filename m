Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbXHCMHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbXHCMHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbXHCMHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:07:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:36468 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbXHCMHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:07:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=d4Fp17VXmZ4yEekv6fPle8DYETDqUz3oNp0lVq6X41zkgrWU9NRHzxbhJJAMnzGDBEr9FbiCDfbvpb42UIu+vQK5RzIlevSkl4KucMTfCBKiLrKIG5sh6c0wFl77rCkgOqBKJknXHC1l/GFt6j5F9wuTN78SFhBDopOdjBLs+BA=
Message-ID: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com>
Date: Fri, 3 Aug 2007 07:07:43 -0500
From: "T. J. Brumfield" <enderandrew@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Scheduler Situation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First off, I am an avid reader of the LKML but I'm not a developer.
Admittedly I am a piss-poor C developer who likes to poke around the
code, play with patches and attempt to learn, but in reality at best I
pretend I understand it, and I don't really.  I fully defer to the
technical knowledge of far greater minds on this list.  Even having a
basic understanding of C and looking at the code, I still don't
understand basic kernel operations like memory management or CPU
scheduling well enough to see in code what works best.

What I can say, is that someone who has had years of project
management experience, it is painfully obvious here that there are
events here in personal issues which should be easy to spot and
rectify.

I, like many people, had been using Con's patches for years and were
greatly pleased by them.  I've experimented with a variety of kernel
flavor and patches, often woefully trying to amass my own collection
of custom patches and often breaking things while trying to integrate
too many patches at once that don't patch nicely with one another.
And when I've had questions, I often read through Con's mailing list
archives from his site.

It would appear he spent 4 years working on his patch-set, primarily
based around his version of a scheduler.  And in reading the LKML it
seems that aspects of his patch-set he pushed for mainline inclusion.
He was shot down saying that his ideas were flat-out wrong, and still
he worked for years to improve his work.  He answered questions, fixed
bugs, and made himself very available.

It may very well be that CFS is a better scheduler than SD.  Ingo is a
very respected coder, and from even Con's mouth it seems that CFS is
pretty simple in its execution.  Ingo seems to suggest that since he
posted his code so quickly after he wrote it, that he didn't do
anything wrong.

Linus, a man I greatly admire and respect, especially for his
blunt/terse statements, also seems to suggest that no one has wronged
Con here.  However in insisting that the decision was based on Con's
inability to support his code, I can fully understand why Con would
leave kernel development permanently.

The simple truth is that Con poured years into a project despite being
rebuffed and told he was wrong.  The moment that people change their
minds and realize that his concepts have merit, no one apologizes for
all the past criticism.  Ingo did very much credit Con for
inspiration, but I can't see how this decision was anything but
political.  Linus said it himself, that he trusts Ingo to stand behind
the code, and he didn't trust Con to do the same.

I am reticent to accuse anyone of dishonesty, but that statement just
doesn't seem to add up.  And even if that is the way Linus truly felt,
it doesn't seem fair given how well Con had supported his code and his
users.  Regardless for a man who claims to not make political
decisions on code, that is exactly how he operated here.  He chose the
person over the code.  From his own mouth, it seemed he remains very
put off by earlier comments from the "Con camp" that perhaps there
should be separation between the server and desktop kernels.

And while Linus is no-doubt correct that such a separation should not
occur, I never really saw Con push for such a thing.  I know I don't
fully understand the code, but it does seem to make sense to an idiot
like me however that with all the other kernel options to customize
your build for your needs, it isn't beyond reason to go with a
plugsched type solution.  The kernel is already immensely modular, no
doubt the most modular piece of code on the planet.

It works amazingly well in small embedded devices to large
multi-processor servers across multiple architectures and processor
types.  The reason I'm posting on an issue I'm sure that many people
are already sick of, is that I'm sure many people would like to see
two things happen.

1 - Can someone please explain why the kernel can be modular in every
other aspect, including offering a choice of IO schedulers, but not
kernel schedulers?

2 - Can't we all agree that this was poorly handled?  Politics should
not affect code, and we are all adults.  People should accept
rejection of patches, and what not.  At the same time, if I were Con
I'd be extremely hurt, and many people have echoed this very
sentiment.  I think a project of this size that depends so much on a
large community for testing, contributions, etc. can't afford to
alienate people in this fashion.  Con may never come back to kernel
land.  That's unfortunate, but this needs to be addressed.  I'm sure a
whole lot of people would feel better if they knew this kind of
treatment is not likely to happen again, and ideally I think Con
should get an apology.

If I'm a developer who sits outside the usual circle of contributers,
and I have an idea for a big change in the kernel, how likely am I to
devote a bunch of time if I have the impression that my work will be
shot down, rewritten by another person, and lastly I will be
personally attacked rather than thanked for my contributions?

I'm really hoping that we can take moment to display some
consideration for the feelings of others here, not to babysit or
placate, but rather to set a precedent for such an important project
on how contributers will be treated.

-- T. J. Brumfield
"In the beginning the Universe was created. This has made a lot of
people very angry and been widely regarded as a bad move."
--Douglas Adams
"Nihilism makes me smile."
--Christopher Quic
