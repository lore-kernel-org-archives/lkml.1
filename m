Return-Path: <linux-kernel-owner+w=401wt.eu-S965730AbXC1TwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965730AbXC1TwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965731AbXC1TwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:52:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:18644 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965730AbXC1TwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:52:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bX0R2IeG1ILWTpJksyd7/iHvoKwXB223i37Q6QFlSSymewJFLVaB5uoCuV1JtUZ2Itj8N+x4smrvyrFJbN+stwxz6uScCv+y7QKlWEjr/6INmp/qoaHrDAOrj1Tr6qsN0QBSGlw2adqEdr5Cah/FHyANoKeGnOQult1iVPNzmVM=
Message-ID: <79489c230703281252s526b3f63vae3dcbb5eaeeb809@mail.gmail.com>
Date: Wed, 28 Mar 2007 21:52:09 +0200
From: "Shlomi Fish" <shlomif@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [Meta] The Linus Bus Factor
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

I'm writing from my gmail.com account so I won't be overwhelmed with
the incoming email.

---------------------------------------------------------------------------

The purpose of this email is two-fold:

1. To make sure that Linus Torvalds hits himself with a bus. I.e.: resigns
from his role as the benevolent dictator of the Linux kernel, at least
temporarily.

2. To advocate the enactment of a central git repository with several
commiters.

I'll start with No. 2.

>From what I understood, at the moment, only Linus can commit or accept
pulled changes to the repository of the vanilla tree. Other people have their
own personal repositories as well. This system works, but I believe it is
sub-optimal. Here are some examples why:

1. Subversion. 126 people with a commit bit - some of them inactive, but
still. I recall being present at #svn or #svn-dev on Freenode and seeing the
commits come by from the CIA bot constantly. (Some people apparently never
sleep).

2. Pugs. Audrey Tang is extremely liberal about giving people commit access.
She gives it to practically everyone who asks or who has something to
contribute just so she or whoever, won't be bothered with committing it
themselves. Even I received a commit despite my notorious perl6-critique essay
([1]). Larry Wall has said that it makes Pugs a happy commune.....errr family.

And Pugs still works pretty well, even if it is slow.

3. KDE. KDE takes this to extreme. 100s of people with commit access - perhaps
even 1,000s. Commits are handed out liberally. And yet KDE works very well,
has many features, and is mostly bug free. It is so good that even the Linus
uses it, and has advocated.

Just for completeness sake, I should note that it also exists to some
extent with GNOME, but I cannot testify how liberally the commits there are
given. I have a commit bit there, too, but it took me some more time than
with KDE, where I received it as a birthday present for my 24+57/365's
birthday.

---------------

None of these projects are using git - they are using Subversion now, and some
of them were using CVS to a great degree of the same effectiveness beforehand.
And they are all doing very well, and the integrity of the code is preserved.

Now, if we have the same for the Linux kernel (and I believe git has no problem
allowin it), then it will simplify processses, facilitate commiting some simple
changes, and generally make everyone happier. If Al Viro (for example) can
commit directly to the central repository a patch that re-indents some code,
it will be a better idea than to have him commit it to his own and then request
Linus to pull it from there.

Note that many commiters does not mean anarchy. When I got a commit bit to
the central Subversion repository, I still submitted most patches for peer
review, because I was not confident to apply them myself. The same happened
with the GIMP, where I received a full allowance to do whatever I pleased
with the gimpressionist plug-in, but still was not confident in commiting my
patches directly to the GIMP core without consulting anyone. So I sent them
to peer review on the GIMP bug tracker, and after everyone were happy with
them (which ususally involved several iterations), I was able to commit them.

What the KDE people do is that they ensure the quality of the SVN snapshots
by monitoring the commits feed, and by testing them extensively. And it works:
KDE is relatively bug free, and works pretty well, despite the fact that
everyone and his sister-in-law has a commit bit.

Note that you don't have to depend on Linus or whoever to do this. You can
simply take the initiative and give commits to your own repository to people
who trust. You can call it a subversive (pardon the pun with svn) movement.
Linus may disapprove but since Linux is open source, you don't need to ask
him. If Linus wishes he can eventually pull the relevant changes from the
multi-commit repository.

------------------

Which brings us to issue No. 1:

Ben Collins-Sussman and Brian Fitzpatrick talk in http://xrl.us/vhak about the
"bus factor": how many developers need to be hit by a bus so a project would be
neutralised. This number is probably very high for the Linux kernel, as many
people know its internals in and out.

However, I'm worried about something slightly different. I'm worried about the
fact that Linus Torvalds started the Linux kernel project, and is still
heading it after 14 years, where it evolved from being a toy, to an
"enterprise-grade, industrial strength" kernel that is used anywhere from
8 MB embedded devices to super-computers, not to mention being the second or
third most popular desktop system (and second on IBM PCs) and the second or
first most popular for servers.

I'm not saying Linus is not doing a good job - almost everyone agrees that
he has been doing an exceptional job. However, being the benevolent dictator
( "for life" ) has made him the bottleneck, the poster boy, the scape goat, the
ultimate authority, and lots of other roles that he defaults to play. This is
unhealthy for the project.

It is known that Solon ( http://en.wikipedia.org/wiki/Solon ) said he was
leaving Athens for a trip around the world, in the midst of his reform for
several years. But he in fact moved to a nearby Island where he observed
by proxy how they managed without him. Without being an insider of the Linux
kernel mailing list, I believe Linus voluntarily leaving will have a positive
effect.

At the moment everyone default to Linus, but if he "hit himself with a bus",
they'll have to manage without him. This will eventually lead to a better
internal organisation, and a much more robust solution. There might be a
different benevolent dictator. There might be a central git repository with
many committers. There might be something. But it will be better than it is
today.

I hate the term "benevolent dictator *for life*", because it assumes the person
cannot be overthrown or that there cannot be a mutiny (my term for coup)
against him. A benevolent dictator in the free software world must not be for
life because he may not be the best solution for ever.

Now that I think of it, I find it said that people think of the Linux kernel
project as "Linus Torvalds' baby". Compare it to KDE which is a large amorphous
meta-project, with no-one known in particular, to Subversion, which while
having many prominent contributors has no poster child. And then there's Perl,
which while Larry Wall is its undoubted demi-god, has many other prominent
figures.

Of course, like I said, you can do a mutiny without asking Linus, by starting
out a central repository for the kernel with many commiters. If this works,
then this repository may eventually become the de-facto kernel (and Linus
would no longer be the benevolent dictator). If it won't work, then we're not
better off, but very little time was wasted.

Linus *can* resign willingly, which may be even more desirable. However, the
Linux kernel is a FOSS project after all, and if you don't like something, you
can always fork it, or at least create your own branch, patchset, etc. in the
version control repository.

Let the flames begin!

Regards,

    Shlomi Fish

[1] - http://www.shlomifish.org/philosophy/computers/perl/perl6-critique/


------------------------------------------
Shlomi Fish http://www.shlomifish.org/

Electrical Engineering studies. In the Technion. Been there. Done
that. Forgot a lot. Remember too much.
