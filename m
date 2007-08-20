Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbXHTPNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbXHTPNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbXHTPNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:13:09 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55805 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760058AbXHTPNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:13:08 -0400
Date: Mon, 20 Aug 2007 11:13:06 -0400
To: Marc Perkel <mperkel@yahoo.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Phillip Susi <psusi@cfl.rr.com>, Valdis.Kletnieks@vt.edu,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
Message-ID: <20070820151306.GD9412@csclub.uwaterloo.ca>
References: <20070818181959.GP21089@ftp.linux.org.uk> <900404.40407.qm@web52501.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <900404.40407.qm@web52501.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 09:07:05PM -0700, Marc Perkel wrote:
> No Al, there isn't any shortage of arrogance here.

Yes you provide plenty yourself.

> Let me try to repeat what I'm talking about as simply
> as I can.
> 
> First - I'm describing a kind of functionality and
> suggesting Linux should have it. I know a lot of it
> can be done because much of what I'm suggesting is
> already working in Windows and Netware.

And how many limitations does windows and netware have that linux
doesn't have, exactly due to that special functionality?  part of the
usefulness of permissions on unix is that they are so simple to
understand and manage.  They are really hard to screw up.  The
permission systems on windows and netware are much more complex and much
hardware for people to understand, and hence much easier to get wrong
causing potential security problems on your system without you realizing
it.

> I'm not the one who's going to code it. I'm just
> saying that it would be nice if Linux had the
> functionality of other operating systems - and - take
> it to the next level - match it and do even better.

Many of the bugs of other operating systems would be nice to avoid.  In
some cases what you may see as a feature is a major cause of problems
especially performance problems.

> As to thinking outside the box, what I'm proposing is
> outside the box relative to Linux. It's not as
> original as compared to Windows or Netware which is
> even better.

How about dropping that stupid phrase.

> The idea is that Linux is lacking features that other
> OSs have. What I'm suggesting is that Linux not only
> match it but to create an even more powerful rights
> layer that is more powerful than the rest and I'm
> outlining a concept in the hopes that people would get
> excited about the concept and want to build on the
> idea.

Well so far your system has been shown to be very inefficient (with no
solution to that proposed by anyone).  Many of the ideas have been shown
to have been tried in the past and then abandoned due to not working
very well or having severe scalability problems.

There are lots of people (very often people currently in university) who
suffer from the problem of believing anything they think of that isn't
in current use must be a new unique idea that must be used because no
one else had thought of it.  In almost every case it is not a new idea,
and the reason it is not in use is because it didn't work the last time
someone thought of it and tried it.  Or in some cases it is in use but
just not in a field the new genious has any knowledge of.

> I'm just telling you what I'd like to see. I'm not
> going to code it. So I'm only going to talk about what
> is possible. How it's done will be up to any
> programmers who might be inspired by the idea. If no
> one is inspired the Linux will continue to be in last
> place when it comes to file system features relating
> to fine grain permissions.

How do you know what is possible?  Could it be that many of the problems
on netware and windows are caused by their choice of filesystem design?

> In Linux, for example, users are allowed to delete
> files that they are prohibited from reading or
> writing. In Netware if a user can't read or write to
> the file they won't even be able to see that the file
> exists, let alone delete it.

In some cases it makes sense.  After all you are not deleting the file,
you are delting one hardlink to it and the hardlink is part of the
directory.  If other directories have hardlinks to the same file, those
get to stay around.  Hence the permissions make sense.

> In Netware I can move a directory tree into another
> tree and the objects that have rights in the other
> tree will have rights to all the new files without
> having to run utilities on the command line to
> recursively change the permission afterwards. 

Does netware have hardlinks?  Does it have chroots?  bind mounts?  How
about the ability to delete open files without causing problems for
programs that have the files open?

> The point - Linux isn't going to move forward and
> catch up unless there is a fundamental change in the
> thinking  behind Linux permissions. There is a
> cultural lack of innovation here. I discussed this
> with Andrew Morton and he made some suggestions but
> there's real hostility towards new concepts here.
> Something I don't understand. At some point Linux
> needs to grow beyond just being an evolved Unix clone
> and that's not going to happen if you don't think
> differently.

Linux seems to be gaining ground in usage.  Netware on the other hand
seems just about dead.  What does that say about things?

> I still believe that the VI editor causes brain
> damage. :)

You should see what word and notepad do to people.

--
Len Sorensen
