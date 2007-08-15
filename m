Return-Path: <linux-kernel-owner+w=401wt.eu-S934584AbXHORea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584AbXHORea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760355AbXHOReP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:34:15 -0400
Received: from web52506.mail.re2.yahoo.com ([206.190.48.189]:33603 "HELO
	web52506.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763134AbXHOReN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:34:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=tpkSDtaxx3hnIh8p+p+iAEVF8tBPHSkd+fDg1PLWbXQeLtpAkli7G1t4n3q6wn1RVOOZqrnUcotfWqiVK9OOYdbGYldMNTAFR0gKnhpF5oG3BJPbEcXC45q7/NSXnUrv8iTYUDBi4+UGXhVJYeOMiNr8HQUaw4AddEw19O6v578=;
X-YMail-OSG: 5fOBESIVM1nL8D5fC6ZyvQQGrh3j_6fhkYUIfFzAiXGCjNKap2_19ImEDLAlLoVgdi1euHh08IFLLT1f9Jh77ca0SZY5jVMJGGif32x8vWgJDnr_jlofp4xUvYkDwrdqYIc3Iqlxl_T4MJuHH9zfbPmhpQ--
Date: Wed, 15 Aug 2007 10:34:11 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Valdis.Kletnieks@vt.edu, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <A631EFDE-354D-498E-980E-2B785517AC51@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <922139.21476.qm@web52506.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Aug 15, 2007, at 13:09:31, Marc Perkel wrote:
> > The idea is that people have permissions - not
> files.  By people I  
> > mean users, groups, managers, applications
> > etc. One might even specify that there are no
> permission  
> > restrictions at all. Part of the process would be
> that the kernel  
> > load what code it will use for the permission
> system. It might even  
> > be a little perl script you write.
> >
> > Also - you aren't even giving permission to access
> files. It's  
> > permission to access name patterns. One could
> apply REGEX masks to  
> > names to determine permissions. So if you have
> permission to the  
> > name you have permission to the file.
> 
> Please excuse me, I'm going to go stand over in the
> corner for a minute.
> 
> *hahahahahaa hahahahahaaa hahaa hoo hee snicker
> sniff*
> 
> *wanders back into the conversation*
> 
> Sorry about that, pardon me.
> 
> I suspect you will find it somewhat hard to convince
> *anybody* on  
> this list to put either a regex engine or a Perl
> interpreter into the  
> kernel.  I doubt you could even get a simple
> shell-style pattern  
> matcher in.  First of all, both of the former chew
> up enormous gobs  
> of stack space *AND* they're NP-complete.  You just
> can't do such  
> matching even in polynomial time, let alone
> something that scales  
> appropriately for an OS kernel like, say, O(log(n)).
> 
> Cheers,
> Kyle Moffett
> 


Keep in mind that this is about thinking outside the
box. Don't let new ideas scare you.

I'm not suggesting that the kernel contain perl. I'm
saying that you can let the kernel call a perl program
in user space to control part of the permission
system. There are examples of this in FUSE. What I'm
suggesting would be very FUSE friendly.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
