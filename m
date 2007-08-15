Return-Path: <linux-kernel-owner+w=401wt.eu-S934367AbXHORT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934367AbXHORT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbXHORTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:19:18 -0400
Received: from web52501.mail.re2.yahoo.com ([206.190.48.184]:30608 "HELO
	web52501.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756740AbXHORTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:19:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Dk33xL+URs61QAUms2z8zHsTTpIySOS/hvn8172EIsQ29hcrvGYybCWeM9X8M7PggKVSr7fcdjN7QdYk6ioa3oMXSYd0wSZWwogUW6n4DRMllFZpECZbjRzJmasKEcMP3vi6tBby1dLBPFGjpzY+vuygT3tr3l6Ebi6HjxOKGgg=;
X-YMail-OSG: XRbIiFsVM1nC4L1XE3O.FYnTZYw3syMtxsQergDJkf0PyA9TGzRCLJq643l94iIHFw--
Date: Wed, 15 Aug 2007 10:19:16 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <08054D5B-FDC2-4A79-8599-E135432E9B45@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <174219.56922.qm@web52501.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Aug 15, 2007, at 12:02:41, Marc Perkel wrote:
> > Kyle, thinking further outside the box, files
> would no longer have  
> > owners or permissions. Nor would
> > directories. People, groups, managers, and other 
> objects with have  
> > permissions. One might tag a file with the object
> that created it  
> > so you could implement "self" rights which might
> be use to replace  
> > the concept of /tmp directories.
> 
> Well, that's actually kind of close to how SELinux
> works.
> 
> This is the real fundamental design gotcha:
>    Our current apps *AND* admins speak "UNIX" and
> "POSIX".  They  
> don't speak "MarcPerkelOS" (or even "SELinux").  As
> long as there is  
> not a reasonably-close-to-1-to-1 mapping between
> UNIX semantics and  
> your "outside the box" semantics, the latter can't
> really be used.   
> It would just involve rewriting too much code *AND*
> retraining too  
> many admins from scratch to make it work.  Hell,
> even Windows and Mac  
> have moved towards a UNIX-like permissions system,
> precisely because  
> it's a simple model which is relatively easy to
> teach people how to  
> use.  ACLs are just a slight modification of that
> model to allow two  
> things:
>    (A) Additional user/group permissions
>    (B) Default permissions for new child
> files/dirs/etc
> 
> People are having a huge problem with SELinux
> permissions as is, and  
> portions of that are a fairly standard model that's
> been worked over  
> in various OSes for many years.  I seriously doubt
> that anything that  
> far "outside the box" is going to be feasible, at
> least in the near  
> term.
> 
> Good new filesystem developments are likely to be
> ones which preserve  
> the same outer model, yet allow for
> deeper/more-powerful control for  
> those users/admins who need it.
> 
> Cheers,
> Kyle Moffett
> 
> 

Kyle, What I'm suggesting is scrapping all existing
concepts and replacing them with something entirely
new. Posix, Unix, SELinux go away except for an
emulation layer for backwards compatibility. What I'm
suggesting is to start over and do it right. 

If this new idea is implemented then one could
implement POSIX as one of many permission modules that
one could load. One could also load a WINDOWS
permission model that could be used with SAMBA. This
would be a new more powerful underlying layer that can
be used to emulate anything you want. And it would be
great for people using FUSE who could make file
systems look any way they want.

One of the problems with the Unix/Linux world is that
your minds are locked into this one model. In order to
do it right it requires the mental discipline to break
out of that.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Looking for a deal? Find great prices on flights and hotels with Yahoo! FareChase.
http://farechase.yahoo.com/
