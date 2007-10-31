Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbXJaJDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbXJaJDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbXJaJDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:03:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:56677 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbXJaJDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hZOwviFbV2CSP5M30j7necDvbt9BunZlfCr6Q5TPJP5GeUFMSPWSuMgS/NiollOcQ17GBnYbQZRQdCEb5YzcxSUu8Zr0fbDJBDZ0m59txa8woBENxsBsKEF3+6eUo1DOa13gJBL8QurFHaB/WkiB4wQ8CAT707/Boov17cBENK0=
Message-ID: <e7d8f83e0710310203x256b3814ibfb4c8c0958780cb@mail.gmail.com>
Date: Wed, 31 Oct 2007 19:03:41 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
In-Reply-To: <472823FA.80303@crispincowan.com>
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
	 <e7d8f83e0710301921m3460f8dfkce72c4fc549ded4a@mail.gmail.com>
	 <472823FA.80303@crispincowan.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, Crispin Cowan <crispin@crispincowan.com> wrote:
> Peter Dolding wrote:
> > Lets end the bitrot.  Start having bits go into the main OS security
> > features where they should be.
> >
> Linus categorically rejected this idea, several times, very clearly.
>
> He did so because the security community cannot agree on a
> one-true-standard for what that OS security feature set should be. From
> looking at this thread and many others, he is correct; there is no
> consensus on what the feature set should be.
>
> So you can wish for the "main OS security features" all you want, but it
> is not going to happen without a miraculous degree of consensus abruptly
> arising.
>
Not really.  Every time Linus has rejected is when people have tried
to thump complete models like Selinux into kernel as one huge mother
of a blocks without grounds.

MultiAdmin is different most other models.  Please look at Posix File
Capabilities.  Grounds and security advantages of that module was
proven while not fighting with other LSM means to do protection.
There are grounds for many admins in linux for tracking admin
alterations.  It falls into a cat of a feature request and security
feature.  Of course not all of MultiAdmin features will be suitable at
main OS security features.  Yes MultiAdmin will have to be happy to
break there code up to get the as there key feature to as many users
as able.  This is a difference UID 0 all powerful I guess everyone
here can agree that is not exactly good.  Not being able to trace who
did alterations as UID 0 is not good either.  Where does the other
frameworks deal with it.

The path is still open into kernel.  Complete models of course are
never going to make it.  100 percent consensus is not always required.
 Same reasons for Posix File Capabilities providing a segmented SUID
feature.  Applying the same Capabilities on a user by user base also
has equal advantages instead of having UID 0 or not UID 0.

Next important question why not look at segments to put forward
consensus.  This is something is not clearly being looked for.

100 percent consensus has never been true for every feature in Linux.

>On the contrary, security, done well, is a tight fitting suit. It must
>be tight, or it allows too much slack and attackers can exploit that.

I love that quote.  There is difference to tight fitting and covering
everything needed.  Ie tight fitting suit without pockets is going to
be a pain.

Main OS security features always made tight by the LSM.  Since they
are override able.

This can solve the stack problem to a point.   Of course not a perfect solution.

Chain passing threw LSM is not a solution.  Never will be.  A
applications on systems may require many different security models to
protect them.

Needing hooks everywhere with unlimited control provided at a single
interface does not look like a tight security model to me.  Makes LSM
look like the Ideal rootkit location.

LSM bundling hooks into security interfaces segments and reduces
threat.  Since each interface has rules and limitations.

Of course my ideas have not been fully documented out correct.   I am
not foolish my skills are not perfect.  The reason behind my ideas is
to get past the limitations of LSM.

The differences between LSMs get less different the closer you get to
the LSM interface.

Label vs path based is the biggest divide.   Including the config
system of modules makes merging hard.  Catch is Label and path based
both have there places.  Ie filesystem limitations(path based) and
speed(label based).  So both being side by side in the kernel I have
no issue with.  I really have to ask why selinux does not support path
based for the odd file systems that don't support labels and the
reverse with apparmor?  Is it that the developers have been building a
empire and not see the need for the others features so failing
completely to build the most powerful security framework.

Yes LSM is only a testing ground and for features that no everyone
wants.  ie Not everyone wants selinux apparmor... Models.  For things
like posix file capabilities its just a testing ground for features
before it moved into kernel full time.

LSM has two uses. Not one.

'one true security model' I am not talking about that with Multiadmin
main goal is a Security Feature it really does not make up a complete
model in its own right.  Different Admins with different capability's.
 Now the final form of Multiadmin who knows.  If we had file access
controls at the same level of control as posix file capabilities there
is a chance that Multiadmin core features could be done threw pam.
Lack of core features is forcing things into the LSM level that may
not need to be there.  Having users with permissions more limited to
filesystem would be useful.  There are small fragments of LSM that
have uses out side the LSM framework also what you are failing to
offer.

This is the problem with Multiadmin its existence is truly
questionable.   Why does it exist where it does.  Even why it exists
at all.  Same applies to apparmor.  Why does it exist should it exist
complete a LSM or should it be cut in two standard OS feature and a
LSM.   Apparmor style file control would be great at a application
level like posix file capabilities.

Note all the core features do make a security model in its own right.
 Wish to enhance that should be equal goal to making LSM's.  They key
thing to the core security model is flexibility.  So of course Linus
does not want to choose a new model he already had one.

Peter Dolding

PS This is most likely no what people want to hear.
