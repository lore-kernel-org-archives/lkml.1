Return-Path: <linux-kernel-owner+w=401wt.eu-S1760523AbXKDB2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbXKDB2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 21:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbXKDB23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 21:28:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:50514 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbXKDB21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 21:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mV//3A737bEhmWtngEIz43Pv6enKgWWQoV+q6rSVp9A+anzLZCiH5Ouylr/G00OcHpnZjhL/de8BzYfsuNNXhmciI6wC6nMapx5ghuSVR3nW9sXQUcKBjPxJoyFnqixC3JOPxngXosla0y0T/bqrPUt60bimzpwacfWT07s3q7U=
Message-ID: <e7d8f83e0711031828i4bbc138eo274e1583d4fe58d3@mail.gmail.com>
Date: Sun, 4 Nov 2007 11:28:26 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "David Newall" <david@davidnewall.com>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>, casey@schaufler-ca.com,
       "Toshiharu Harada" <haradats@gmail.com>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4729BD60.3030105@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7d8f83e0710311904w45827586oabcca597fd612ea6@mail.gmail.com>
	 <832119.21078.qm@web36614.mail.mud.yahoo.com>
	 <e7d8f83e0710311951nd162a27rb2134e3b21e299a8@mail.gmail.com>
	 <Pine.LNX.4.64.0711010813130.5103@fbirervta.pbzchgretzou.qr>
	 <4729BD60.3030105@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/07, David Newall <david@davidnewall.com> wrote:
> Jan Engelhardt wrote:
> > On Nov 1 2007 12:51, Peter Dolding wrote:
> >
> >> This is above me doing code.   No matter how many fixes I do to the
> >> core that will not fix dysfunction in the LSM section.  Strict
> >> policies on fixing the main security model will be required.
> >>
> >
> > If there is no one wanting to fix the existing code, then the
> > perceived problem is not a problem.
>
> What an absurd claim.
>
I agree.  If they can provide a reason.  A correct reason why its not
being fixed then the perceived problem does not exist.  Until then it
common human flaw Tunnel vision.  People normally don't look at the
big picture.

Common fake reason is that Linus does not approve.   History of
patches completely disagrees with that.  Parts Linus has blocked have
been out of alignment with the build into kernel security model.  Yet
other parts that were in alignment with the model have got in during
the same time.  Perfect example of dysfunction making up a lie because
things will not go into kernel exactly how they want.

LSM is nothing more than a testing and model zone.   A place were
important features should not be.  It was put there because model
designs could not get along.   Did that mean that LSM was were the
features were intended to stay.  No the goal should be simple to get
as many good features into the main line as possible while staying in
alignment with the main kernels model.  I don't know where the wrong
idea that the main line did not have a security model came from
either.  Something does not have to be a LSM to be a security model.

XEN, KVM and lguest are not a suitable workaround to problem.  Its
more of LSM developers trying to say its not needed so don't have to
work with each other.  I am not always using x86 machines so at times
not one of those solutions fit.

Containers in Linux kernel get to be processor neutral in features.
So it will not matter what the processor chip it will work.  So the
correct solution to running many LSM somehow has to be done with
Containers.

Note calling me a know it all is not an answer either.   Either they
can put have a good explanation for there failing or the need asses
kicked.  Heck if I am wrong I need ass kick and perfectly prepared to
accept it.  The problem is I am not a person to accept invalid answers
what they have been giving me so far.

My main base is System Administration.  Not coding please note that
System Administrators are the final clients.  If you want someone with
System Administration back ground to take up the leadership of LSM and
bash it into a System Administrator friendly shape I am more than
prepared to do so.  I can bet a System Administrator in charge who is
looking from flexibility's and security point of view is going to get
noses really badly out of joint.  The flexibility bit is currently
missing.   Its not always possible to reboot a server just because the
security framework is not up to the job or client wants you to use a
tighter model.

Yes so people trying to lie to me is something I have very little
tolerance with.  Paperwork like PHD don't scare me off.  I have had to
repair networks destroyed by people with PHD with masters in computer
programming because they run a BIOS destroying virus from a outside
source.  So lets just say my trust has to be earned and using
incorrect facts don't get trust from me.

There is a bigger one than just Containers.  Its called linux on
desktop.   Some how security models will have to tolerate being
controlled from a central server.  Preferred 1 model so any number of
Linux Distros can be used in a network.  Just like different versions
of windows can now.  So somehow we have to get to one master model.
Even if the other models are just like feature tweaks.  Application
controlled allows pam and ldap into play.

Selinux jamed in does not really suit what is needed.  The world of
Linux is changing the LSM need to get there but into gear and catch
up.

Peter Dolding
