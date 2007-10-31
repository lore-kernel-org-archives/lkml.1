Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbXJaCVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbXJaCVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 22:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXJaCVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 22:21:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:59574 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbXJaCVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 22:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mjjCGyjcuB9M/eO3P4ctXs/frve3ngS+TNFJDvIZ1RRBn9VYhstixLlGIhXicEBeJ849waNr32pUNTfu7L2dNzXtJ94VuAuWrXFXEkc8k//YzTPi8G1lJOuLmGqleRH3ZUWYYmLtOUER3EmntAA9i6vu6Cj1rgAGnBjmUEAJQ5E=
Message-ID: <e7d8f83e0710301921m3460f8dfkce72c4fc549ded4a@mail.gmail.com>
Date: Wed, 31 Oct 2007 12:21:07 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
In-Reply-To: <Pine.LNX.4.64.0710301713260.8703@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>
	 <4726377A.4080807@crispincowan.com>
	 <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
	 <Pine.LNX.4.64.0710301136560.31325@fbirervta.pbzchgretzou.qr>
	 <4727C06A.4060005@gmail.com>
	 <Pine.LNX.4.64.0710301713260.8703@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, david@lang.hm <david@lang.hm> wrote:
> On Wed, 31 Oct 2007, Peter Dolding wrote:
>
> > MultiAdmin loaded before Selinux breaks Selinux since Multi Admin rules are
> > applied over using Selinux rules.  This is just the way it is stacking LSM's
> > is Just not healthy you always risk on LSM breaking another.  Part of the
> > reason why I have suggested a complete redesign of LSM.  To get away from
> > this problem of stacking.
>
> since the method of stacking hasn't been determined yet, you can't say
> this.

I can because that is the current day problem. With many LSM's loaded
they stack completely as a complete mess and with problems.  They
fight with each other.  Lack of define on stacking equals big
problems.   Since you have not created a standard for stacking does
not stop the problem from existing.  Nice lack of planing when LSM
started or maybe its intentional.  When you need stacking its about
time you start moving things into the OS?

There is a way around the problem too without allowing LSM to stack.
Good advantage backward compatible  because your are not playing with
the LSM standard to do it so no LSM modules should need large
alterations.  At worse mirror extensions to handle the new OS feature.
 Posix File Capabilities provide the solution.   First done as a LSM
risked conflict.   Moved in as a operating system extension by by
conflict.  Fragments from LSM's should exactly move that way if they
expect to be overlapped by other models.

Lot of stacking problems can be avoided if segments are complete
standard extensions.
>
> it would be possible for MultiAdmin to grant additional access, that
> SELinux then denies for it's own reasons.
>
> if the SELinux policy is written so that it ignores capabilities, and
> instead just looks at uid0 then that policy is broken in a stacked
> environment, but it's the polciy that's broken, not the stacking.

That is not how current day always works.  MultiAdmin grants and that
can be the end of the treeing.   Selinux does not get asked if it
refuses it or not.  So no matter what was set in the Selinux policy it
may never get used.   Adding more layers is also bad for performance
to.  Treeing threw modules for rights is a really slow process.  As
like a posix feature extension.   Selinux/Other LSM's is at top of
allocation no flaw no bypass.

> yes, there will be interactions that don't make sense, but just becouse
> something can be used wrong doesn't mean that there aren't other cases
> where it can be used properly.
>
We are talking security here if its not order safe its not good.
MultiAdmin done as a posix feature extension is order safe.
MultiAdmin done as a LSM is not order safe.

System Admins are humans too.  Getting orders backwards does happen.
So should be avoided where able.

This completely avoids the need for adding another layer of stacking
and since built inside current day framework.  Does doing this risk
the end of LSM's as we know it yes it does.  Since it is not being
used as LSM were intended.  LSM is just a addon to standard OS
security what is either a testing ground for new features to secure
the OS that get build into the OS in time or as location for security
modules.

Somethings should be just done in the Standard OS security nothing to
do with LSM.

Little bit hard for some I guess to hear that LSM are not all
important and not all Security features should be done in them.  Some
should be done in the main OS security features.

Biggest current day problem with LSM is they have forgot that LSM is
only a testing ground or a zone for features that people will only
want some of the time.

MultiAdmin is a feature that can enhance means to Audit OS ie who did
what.  Enhance security hand outs and can be really handy with almost
any LSM on the system.  Its description of what it is sounds very much
like every other standard feature.

Lets end the bitrot.  Start having bits go into the main OS security
features where they should be.

Peter Dolding
