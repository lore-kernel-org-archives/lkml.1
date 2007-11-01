Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbXKACv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbXKACv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 22:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbXKACvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 22:51:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:54647 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbXKACvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 22:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rz5r7zXeMOfx9gLglte/215AxMcLavv1l/J32j2AlJIZGH9FlLKXRrljGL5hT9bEUr+0/Uo5SMAQ1uzVBp/UM45Gzw+8miUW55EvxG6UHhMHGMcVbgO8xP1KPshoY5Sd08JMOoZNCcgbCW+0Mw+uIfbr8ukTJDn7NmxsHXn7KUs=
Message-ID: <e7d8f83e0710311951nd162a27rb2134e3b21e299a8@mail.gmail.com>
Date: Thu, 1 Nov 2007 12:51:47 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: casey@schaufler-ca.com
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
Cc: "Toshiharu Harada" <haradats@gmail.com>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <832119.21078.qm@web36614.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7d8f83e0710311904w45827586oabcca597fd612ea6@mail.gmail.com>
	 <832119.21078.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/07, Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> --- Peter Dolding <oiaohm@gmail.com> wrote:
>
>
> > Improvements to the single security framework are getting over looked.
>
> Please post proposed patches.
>
> >   I would have personally though selinux would have done Posix file
> > capabilities as a general service to all.
>
> Posix capabilities predate SELinux. SELinux is not interested in
> Posix capabilities.
>
> > But no IBM had to do it.
>
> Err, no. It was done by Andrew Morgan back in the dark ages.
> Why on earth do you think IBM did it?


Posix file capabilities the option to replace SUID bit with something
more security safe only handing out segments of root power instead of
the complete box and dice like SUID.  Even different on a user by user
base.

Posix capabilites is what Posix file capabilities is based on.  Yes I
know the words appear close.  The word file is important.  Please read
Website.  http://www.ibm.com/developerworks/linux/library/l-posixcap.html

IBM coders worked and got it into the main line really recently to
provide at least some way to avoid fault of SUID of course it could
still be made better.  I would have though being a important problem
that other LSM guys would have done it first.  So door to add new
features to kernel is open past any question.  Of course the features
have to be for everyones good.

Andrew Morgan Posix capabilities is something far older its been there
for ages pre selinux the correct fix to SUID for everyone has always
been there by extending Andrew Morgan's work.  So I will ask again why
did IBM have to do Posix file capabilities instead of Selinux.
Selinux has had 7+ years to do it.

Thank you for proving my point past question Casey Schaufler.  You
don't have a single clue of the alterations happing to the main
security model so there is every chance you will overlap with it.

Please get you tech right.  How many other holes are sitting open
because you patch them at LSM level and don't look down into default
security system to see if it should be fixed there.

>
> OK, you have all the answers. Show us some code or STFU.

That is no explanation to why the default security frame work is being
neglected.  I don't have all the answers.  It does not take a person
that high so see that LSM is a screwup leading to people being out of
touch with the main security model and its neglect.  It should not be
requiring outside parties to fix things that in the main security
model.  Only way that can be happening is if LSM is dysfunctional.  7+
year fault at min is not what you can call someone fixing a new fault.
 Now how are we going to fix the mess of LSM's to work correctly for
the good of linux.

One way is appoint one hard minded maintainer that is above my rights.

This is above me doing code.   No matter how many fixes I do to the
core that will not fix dysfunction in the LSM section.  Strict
policies on fixing the main security model will be required.

Peter Dolding
