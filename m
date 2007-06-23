Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbXFWHZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbXFWHZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 03:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXFWHZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 03:25:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbXFWHZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 03:25:37 -0400
Message-ID: <467CCAEE.3020101@redhat.com>
Date: Sat, 23 Jun 2007 03:25:34 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
References: <200706212349.54983.zoltan.hubert@zzaero.com>
In-Reply-To: <200706212349.54983.zoltan.hubert@zzaero.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zoltán HUBERT wrote:
> Hello gentlemen (and ladies ?)
> 
> As a power-user (NOT a hacker) I kindly ask you to please 
> change the naming scheme and come back to the traditional 
> model, and release a stable kernel while working on a 
> develoment branch.
> 
> I'm not on the [lkml] so should you answer please CC my 
> e-mail: zoltan.hubert@zzaero.com

Please don't do this.  It's very rude.  It's one thing to report a bug 
and say "Please CC me", but it's quite another to ask us to completely 
change the way we're doing everything without actually observing the 
process.  If you're going to make such sweeping requests like this, at 
least have the courtesy to subscribe to the list and read a sampling of 
the traffic for long enough to realize that the current development 
model, for all its flaws, was developed for very good reasons.

> All people who might read this know that traditionally 
> stable releases are even numbered and development branches 
> are odd numbered. This changed during late develoment of 
> 2.6, according to my analysis because of the "invention" of 
> GIT which was itself necessary because of BitKeeper (insert 
> ooooooooold flame-wars here) and which allowed very dynamic 
> develoment. While this has been effective, alternative 
> voices (Mr Morton complaining that more bugs were added 
> than repaired, semi-stable semi-supported 2.6.x.y branches 
> where invented...) come more and more into the front. The 
> upcoming GPL v3 versus v2 debate will make things worse, 
> and we all know this. The un-ending stable ABI argument 
> goes into this same direction.

What argument?  Userspace ABI is stable, by rule.  Kernel internal API 
and ABI is not.  There is no argument, just people who come along from 
time to time and ask us to do everything the way they like, without 
offering anything in return.

> So I feel that a turning-point is coming where a really 
> really really (x 15) stable and reliable kernel is NEEDED.

That's what vendor kernels are for.  If you don't want to pay the money, 
just download the source and rebuild it yourself.

> You might think it's easy for me to simply "use" Linux and 
> complain while you're doing the hard stuff. As it happens, 
> the current development/stable model makes our life as 
> "users" more and more difficult. I'm using Linux since 1997 
> on a Mac thanks to LinuxPPC-1997, and I'm a hard pusher of 
> Linux whenever possible, sometimes against the common 
> sense, for example when I favor using National Instrument 
> cards with Linux drivers and custom written TCP/IP server 
> against easy LabView on Windows. While some of you dislike 
> closed source drivers, the choices "we users" face are:
> - closed source drivers with closed source OS
> - closed source drivers with open source OS
> Please consider that we are living in a REAL world, and not 
> Disney-Land.

Closed or open, someone somewhere is probably willing to take your money 
in exchange for making it work.  If you're not willing to spend money, 
or offer something else in exchange, then nobody has any reason to go 
out of their way make life easy for you.  The community works to help 
itself, not the freeloaders.  Many of us (such as myself) actually get 
paid to maintain stable releases to ensure a good user experience, so 
we're well aware of the issues you face.

> So I've demonstrated that from a "users" perspective a new 
> stable Linux would be of advantage. I'll now list what I 
> suggest for this new stable branch:
> 
> First, there are some fundamental ideas in the pipelines of 
> forthcoming releases which should be part of the next 
> "stable" Linux (Reiser4, the new scheduler from Mr. Molnár, 
> virtualisation...). So any next stable kernel branch should 
> include most of these recent developments, with the goal of 
> stabilising them. May-be a poll on [lkml] as to which 
> feature to include or not would help ?

Actually, the current architecture is flexible enough that adding these 
things in isn't all that hard.  We already have kvm merged, and the 
scheduler work is proceeding nicely.  Please don't start another Reiser4 
flamewar.

> Second, there was once a suggestion that 2.6 should be 3.0 
> since a lot of things changed:
> - modules called .ko and not .o
> - the output of the compile
> - ... (I don't remember)
> This was a brilliant suggestion and I whish another 
> consideration was given to that idea. You might even go a 
> step further and call kernel modules .kmod. Why on earth 
> call "kernel object" things that are "kernel modules" ? And 
> that every person calls "modules" and not "objects" ? I 
> know I know, in UNIX dynamic libraries are .so "shared 
> objects", so what ? A "module" is a "module" and NOT an 
> "object", call a cat a cat.

These are build trivialities.  This is hardly reason to change the 
development model.

> Third, while a stable ABI in a dynamically developed kernel 
> is a difficult/impossible/unwanted feature, it should be 
> possible to implement in a stable branch. This could even 
> be a distinction between "stable" and "development" 
> branches. And it would certainly help vendors of 
> closed-source drivers.

If I submit a patch to a RHEL kernel that breaks kABI, people knife me 
in the hallways, because I get paid to maintain it.

> Fourth, a finnish developper on this list suggested several 
> times that people should be allowed to try stupid things. 
> Well, I'm doing just that.

No, you're asking *us* to do stupid things.  If you want a more stable 
kABI in the upstream kernel, then start submitting patches that 
implement the hooks you need to do it.

> As a conclusion, please, please, consider splitting again 
> the kernel in 2 distinct branches, one labeled 
> "development" suiting your needs and another labeled 
> "stable" for us users.

It's already been done in a few different places.  2.4.x is still 
maintained.  2.6.16.y is still maintained.  Several vendors maintain 
stable kernels, some even kABI-stable, for many years after release. 
Since the vast majority of users are running distro kernels rather than 
upstream kernels, I think it's fair to say that anything post-2.6.16 
from kernel.org is a de facto development kernel, at least to users with 
extreme stability requirements like yourself.  Find yourself a distro 
that's the right balance of modern and stable, and use that kernel.  If 
there isn't a distro that's both modern enough and stable enough, then 
there are probably some very good economic reasons why this is the case.

	-- Chris
