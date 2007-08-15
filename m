Return-Path: <linux-kernel-owner+w=401wt.eu-S933596AbXHOUU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbXHOUU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXHOUUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:20:11 -0400
Received: from web52512.mail.re2.yahoo.com ([206.190.48.195]:30178 "HELO
	web52512.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750860AbXHOUUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:20:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=YAJkEDELL5PE5rSs/SBGWL/dukaOWy9lly7LiAZhvaO18axGHgzd3Zdj7B8rgMJEqQHCh2b/FJDbgqxydLDqn98u7ElA2wIULnFnLo4HXSpJKrec9ZC6LmDN7f+XlJw35mepFz598uqHsZwYH/w1uj3P8o8BDe4BomftS1HnDvU=;
X-YMail-OSG: BhCHPHsVM1nFs5CAzpEs8bD72eDOHxSM3JKk5uMOoFDQZetq8gG6nEJpaeI_0UHDog--
Date: Wed, 15 Aug 2007 13:20:07 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <A699C8AE-6C16-46FA-9C55-EFA4FA1718ED@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <633206.92836.qm@web52512.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Aug 15, 2007, at 14:05:23, Marc Perkel wrote:
> > In this new system setfacl, chmod, chown, and
> chgrp all go away  
> > except inside of an emulation layer. File and
> directories no longer  
> > have permissions. People have permission to naming
> patterns. So if  
> > you put a file into a tree or move a tree then
> those who have  
> > permissions to the tree have access to the files.
> >
> > It eliminates the step of having to apply
> permission after moving  
> > files into a tree. You don't have to change file
> permissions  
> > because files no longer have permissions.
> 
> And I'm trying to tell you that unless you have some
> magic new  
> algorithm that turns NP-complete problems into
> O(log(N)) problems,  
> your idea won't work.  You can't just say "I just do
> one little thing  
> (mv) and the entire rest of the computer
> automagically changes to  
> match", because that would imply a single unscalable
> global kernel  
> lock.  "Pattern"-matching is either NP-complete or
> high-polynomial- 
> order, depending on how its implemented, and if you
> want to do a  
> recursive-chmod during a directory move then you're
> going to have  
> race-conditions out the ass.  If you have code or
> solid math to back  
> up your postings then please do so, but otherwise
> you're just wasting  
> time and bandwidth.
> 
> 


Kyle - you are still missing the point. chmod goes
away. File permissions goes away. Directories as you
know them goes away. 



Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
