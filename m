Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbXJ2Ncj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbXJ2Ncj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXJ2Ncb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:32:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:64114 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbXJ2Nca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cNfdwnHwN95Rxf04wr+7f/wXxAzx/ISGLaeCdn+5C6fAYONoia+gL8bklGCfI4+BM+SIAHwKJjT8ALnUX7MzlDOvBIFUtQ3h80TeUgCLJYqoeT8DV/p51qwhZ6X1PDGRYUa0nVIQ/FII8/cP0llTrjvVEG8uHkPNf0W6v1Gm/tk=
Message-ID: <e7d8f83e0710290632u135b20det53a2c9b167630b7a@mail.gmail.com>
Date: Mon, 29 Oct 2007 23:32:29 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
In-Reply-To: <4725B4EA.4060303@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15466.80.126.27.205.1193652063.squirrel@webmail.xs4all.nl>
	 <4725B4EA.4060303@crispincowan.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, Crispin Cowan <crispin@crispincowan.com> wrote:
> I *really* dislike this idea. It seems to set up the situation that the
> only acceptable modules are those that follow some "formal" model. Problems:
>
>     * What qualifies as a formal model? This becomes an arbitrary litmus
>       test, depending on whether the model was originally published in a
>       sufficiently snooty forum.

Agree slows development and experimentation with a idea BAD.  I would
more say function and reach of model and how its ment to operate
documented clearly.  So next coder along is not taken wild guess.  It
must be so clearly documented that almost any system admin could
understand how much or how little protection it is providing.

>     * What if someone invents a new model that has not been "formalized"
>       yet? Should Linux be forced to wait until the idea has been
>       through the academic mill before we allow someone to try
>       implementing a module for the idea?

Experimental until documented out of tree following mine.
.
>     * The proposal only allows a single implementation of each formal
>       model. In theory, theory is just like practice, but in practice it
>       is not. SMACK and SELinux follow substantially similar formal
>       models (not exactly the same) so should we exclude one and keep
>       the other? No, of course not, because in practice they are very
>       different.

Drop a stick on both of them.   Since they both operate substantially
similar they should be directly prepared to share code with each
other.   If one is not prepared to work with the other openly and
fairly out the tree it goes.

It could quite simple become the only thing different between Smack
and Selinux in they way they read configuration files.   Long term the
most user friendly and security solid modules win.  So long term one
wins short term any number of models.  We of course wait for that to
happen.  Note it could be agreement between coders.   Since they were
force to work as one if there is merit it will come out.  There is no
room for empire builders.   We need security builders.  Part of that
is getting your code examined by the most number of people able.

Same with apparmor vs selinux both can provide file access filtering.
So why two sets of code to do it.

LSM need a really strong maintainer prepared to beat a few ears in.
Or all we will endup with is usable modules.   Selinux pain in but to
configure no not really usable.   Maybe flaws in Smack so force to use
Selinux.  Apparmor too weak.

Basically a stack of trash is the current LSM model.  LSM's are fast
turning into x86 vs x86-64 bitrot all over again accept this time 100
times worse.  What is basically bitrot caused by not sharing.
Stackable modules maybe.  More important shared source code to do
stuff and common standards between LSM used where able.  This also
should make it simpler for new models to be added and experimented
with.  Since the new model may not need to redo all there hooking
system all over again.  Reduced security risk more tested code used in
new models.

Next more important extend security down into applications if
applications need it.   File access filtering would be a great feature
at the thread level.

We have enough LSM's to be hard. It a privilege to be in the main
kernel tree not a right.  Part of having a module in the Linux kernel
tree is a promise to do what is right for everyones security using the
kernel even if it means the end to your LSM's existence.  Part of
doing what is right is sharing of code.   All LSM developers should be
looking at there code and asking should this be like posix file caps
and for everyone.  Or should this be a LSM only feature because its
useless to everyone else.  From what I am seeing LSM maintainers don't
seam to think its part of the requirement to help other LSM's be
better even if theirs ends up losing.  Only if you are building a
Empire does it matter who wins or loses the long term of LSM's.   Only
thing that truly matter is that we get the best long term.


Peter Dolding
