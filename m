Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbXKACEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbXKACEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 22:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbXKACE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 22:04:26 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:29442 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbXKACEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 22:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Oir9Q+dS4z2IQ63eNfrY5arpQYMslDawLJaI4GteauDpO7euzRP8RoYN2W9xWmsbr9wskW3dHvH3BmbEutRFHSo3xBvIjIT9+0wOHyPOhXjAQajpO7QzWDk3mrZmeDxWchK7II9n7OsExEifnRf2FrRUn1KFxrrzX4josycAhf8=
Message-ID: <e7d8f83e0710311904w45827586oabcca597fd612ea6@mail.gmail.com>
Date: Thu, 1 Nov 2007 12:04:23 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Toshiharu Harada" <haradats@gmail.com>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
Cc: "Crispin Cowan" <crispin@crispincowan.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <9d732d950710310310k4ddd1fefs1ba86e2baf936bb6@mail.gmail.com>
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
	 <9d732d950710310310k4ddd1fefs1ba86e2baf936bb6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Clear and Important thing is there is already a single security framework.

The single security framework is the security that exists when no LSM
is loaded.  It turns out the more I look most of my model already
exists just not being used effectively.  There is a capabilities frame
work at worse needs expanding to handling more detailed controls.
Like X thread can only read x y z files an write to a file.

Improvements to the single security framework are getting over looked.
  I would have personally though selinux would have done Posix file
capabilities as a general service to all.  But no IBM had to do it.
This shows a problem.  Critical upgrades to the single security
framework are not being made by LSM producers.  This means one thing
LSM producers are putting there framework before the good of everyone.
  This just cannot keep on going its a path to more and more forks and
more confusion.

Is it Linus getting in way I think not.   Because upgrades are making
it.  Slowly making it but they are making it.   Is it LSM makers
trying to alter the single security framework to there model.  I am
almost perfectly sure that is the main problem.  Next problem is LSM
vs LSM one up man ship ie mine is better than yours or Mine can do all
yours can with 12 times more complex config file.  Not taken a
complete look to see if both sides have advantages.

Part the problem is if you upgrade the single security framework
enough selinux apparmor... most of the LSM will become side shows of
very little importance to security more a s backup to the main
security.  Focus may move back to the old unix locations.  PAM for
creating users and assigning rights and application controlled
security.

Key thing to put  features into the existing single security framework
is flexibility and application control.  Application controlled
security can always beat selinux apparmor and every other LSM I have
ever seen.  The most advanced design of security just happens to the
one you cannot remove.   It also happens to be the most neglected.
The weaknesses that exist in the single security framework is lack of
advancement and repair.

What I class as features is like a fix to a small part.  Ie SUID too
powerful fine grained controls required.
Disk access control methods for file systems without using the
permission system. << Apparmor and relegated path base back end
engine. This also partly allows applications to protect there own
internal users from each other without needing to create system wide
users.  Basically in time internal application users should be equally
protected from each other as system wide users.  This enhancement goes
far past the common day scope of apparmor.  This is the advantage of
taking it out of LSM or at least looking to.  You may see where it can
be make 1000 times more useful as feature than a LSM and provide many
more times system protection even in ways a LSM never could.  Yes
altered apparmor could be really sell able as a core feature.

There are a lot of parts in LSMs that can be broken down into single
feature enhancements.  Major difference is how these features are
controlled.   Applications must be able to directly lower access on a
thread by thread base.  Never raise it.  These features are also
provided to all users on the system to control always even if they
cannot use them due to lack of rights.

Explain to me how its not bitrot leaving the key security framework
without features and then dividing up those features between different
incompatible parts.  This is the basic define of bitrot because you
are making a bigger and bigger mess.

Peter Dolding
