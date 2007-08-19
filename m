Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbXHSNWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbXHSNWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 09:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXHSNWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 09:22:39 -0400
Received: from web52503.mail.re2.yahoo.com ([206.190.48.186]:31691 "HELO
	web52503.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751465AbXHSNWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 09:22:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xBjkDOiAeGwkZi3fDiDbI3MzHwesFqCy4RSvLxyesMIeky6MbfIRcGSv13nl8l708tH6l5eXFB+4scwszRGTKaFOHYr9/8Qqw2QcLUHibN7PT0b+gdHhvQnI8ch62Jft+3dWL0KR7k7XCQZODS4qYpe3xBdDzlNEbM34pFiip9o=;
X-YMail-OSG: FbgEegcVM1kUJABeawwyQBGqWyHcf0GYGwJ1VgKM9JvNKdm78z_xuePEQlDiTOi8NQ--
Date: Sun, 19 Aug 2007 06:22:37 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: The vi editor causes brain damage
To: Willy Tarreau <w@1wt.eu>, Jiri Slaby <jirislaby@gmail.com>
Cc: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070819072135.GQ6002@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <952949.96475.qm@web52503.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Willy Tarreau <w@1wt.eu> wrote:

> On Sun, Aug 19, 2007 at 09:15:22AM +0200, Jiri Slaby
> wrote:
> > Marc Perkel napsal(a):
> > > Let me give you and example of the difference
> between
> > > Linux open source world brain damaged thinking
> and
> > > what it's like out here in the real world.
> > > 
> > > Go to a directory with 10k files and type:
> > > 
> > > rm *
> > > 
> > > What do you get?
> > > 
> > > /bin/rm: Argument list too long
> > 
> > What does this have to do with rm command?
> 
> Nothing, and no more with linux development. Marc
> confuses shell and rm.
> Under DOS, when he types "del *", the shell calls
> the builtin function
> "del" and passes it only one argument "*". The del
> function is then
> responsible for iterating through the files using
> getfirst/getnext.
> 
> This is also why mostly only builtin shell commands
> support "*", while
> most external commands do not support it, since they
> have to re-implement
> the same code to iterate through the files (try
> "debug c*.com", it will
> not work).
> 
> Under unix, the shell resolves "*" and passes the
> 10000 file names to
> the "rm" command. Now, execve() may fail because
> 10000 names in arguments
> can require too much memory. That's why find and
> xargs were invented!
> 
> The solution is easy : find . -maxdepth 1 | xargs rm
> 
> So this has nothing to do with rm, nor with rm being
> open-source, and
> even less with rm being written with vi, and Marc's
> rant is totally
> wrong and off-topic. Maybe he was drunk when
> posting, or maybe someone
> used his keyboard to make him look like a complete
> fool. Or maybe he
> really is.
> 
> Willy
> (please do not follow up on this OT thread,
> responses to /dev/null)
> 

The important point that you are missing here is that
the Linux world is willing to live with an rm command
that is broken and the Windows and DOS world isn't.
This isn't about the rm command it's about programming
standards. It's about that the Linux community isn't
committed to getting it right.

Just like my thinking outside the box thread when I
try to say "this is broken" people don't go fix it.
Instead I get an explanation why Linux isn't capable
of having an rm command that will delete an unlimited
number of files.

I bet there are Microsoft people out there laughing at
this.

THINK ABOUT IT PEOPLE !!!

20 years, a million programmers, tens of millions of
users and RM is BROKEN. Am I the only one who has a
problem with this? If so - I'm normal - and Linux is a
cult.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________Ready for the edge of your seat? 
Check out tonight's top picks on Yahoo! TV. 
http://tv.yahoo.com/
