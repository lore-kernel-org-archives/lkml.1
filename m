Return-Path: <linux-kernel-owner+w=401wt.eu-S937453AbXGRXl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937453AbXGRXl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936674AbXGRXdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:33:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:14529 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936980AbXGRXdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:33:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LlpfATzYPSkOs451WwH67EjIuxUs2bA2jpSXWOPz61rJ3LNyLWtzFBYUExxyaunny2uyAzKP44OKnGal/dXu9nfUnS7Alda3Imw1O1pChtPkk0WdqABci7ToPpwK42U1dVnfco4W5ZLbhGwZOrK7vPtY7KccT0z0oAEr5AY0lwc=
Message-ID: <3ae72650707181633w244904a6l2cee81d307b7dda1@mail.gmail.com>
Date: Thu, 19 Jul 2007 01:33:19 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Rob Landley" <rob@landley.net>
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>, "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       "Krzysztof Halasa" <khc@pm.waw.pl>, "Rod Whitby" <rod@whitby.id.au>,
       "Russell King" <rmk@arm.linux.org.uk>, david@lang.hm
In-Reply-To: <200707181339.54192.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707171703.31340.rob@landley.net>
	 <20070718095857.5365323a@gondolin.boeblingen.de.ibm.com>
	 <200707181339.54192.rob@landley.net>
X-Google-Sender-Auth: 0a8121f358584000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Rob Landley <rob@landley.net> wrote:
> > >  /sys/block/*/dev
> > >  /sys/block/*/*/dev
> >
> > Note that this will change to /sys/class/block/ in the future.
>
> At OLS, Kay Sievers said in a future version they were going to move it
> to "/sys/subsystem/block", which I can't document right now because no
> current kernel does this, and that path will never work with any previous
> kernel, but there should be a compatability symlink from the old path to the
> new one.

That will be the case.

> He never mentioned /sys/class/block.

So? How about reading your  email?
  http://marc.info/?l=linux-kernel&m=118260305012165&w=2

You seem to miss the the very basic skills to collect the needed
information to do the job of documenting something.

> To all of this, I would like to humbly ask:
>
> PICK ONE!  JUST #*%(&#%& PICK ONE!  AAAAAAAAHHHHHHH!!!!!!!!!

Man, you totally miss the point.

> > > Entries for char devices are found at the following locations:
> > >
> > >  /sys/bus/*/devices/*/dev
> > >  /sys/class/*/*/dev
> >
> > Uh, that is actually the generic location?
>
> It's what Kay Sievers and Greg KH told me at OLS when I tracked them down to
> ask.  I've also experimentally verified it working on Ubuntu 7.04.  That was
> cut and pasted from Kay's email, and it works today.

That is still true, but it still does not tell you the type of node to
create, as you seem to insist on.

> > It may be enough (and less confusing) to just state that the dev
> > attribute will belong to the associated "class" device sitting
> > under /sys/class/ (with the current exception of /sys/block/).
>
> Nope.  If you recurse down under /sys/class following symlinks, you go into an
> endless loop bouncing off of /sys/devices and getting pointed back.  If you
> don't follow symlinks, it works fine up until about 2.6.20 at which point
> things that were previously directories BECAME symlinks because the
> directories got moved, and it all broke.

That's total nonsense.

> Which is why I want it documented where to look for these suckers.  Just give
> me ONE STABLE WAY TO FIND THIS INFORMATION, PLEASE.
>
> This document is trying to document just enough information to make hotplug
> work using sysfs (which includes firmware loading if necessary).
>
> > (And how about referring to Documentation/sysfs-rules.txt?)
>
> Because there isn't one in 2.6.22, and I've been writing this file on and off
> for a month as I tracked down various bits of information?

I invested a lot of time explaining stuff to you in email and
personally, but really, that seems just like a total waste of time. I
will not reply to any of your mails until you have proven to have read
the udevtrigger code, and got a clue how to do stuff reliably, and get
the basic knowledge needed to document it.

Kay
