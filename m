Return-Path: <linux-kernel-owner+w=401wt.eu-S934477AbXHORvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbXHORvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758738AbXHORvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:51:06 -0400
Received: from web52502.mail.re2.yahoo.com ([206.190.48.185]:31512 "HELO
	web52502.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758532AbXHORvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:51:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=e8K1gj4nu84dOso6FpIiXxWJiMdC4Y/h1l5eO+GbgaR3xNhrxwLFMBFZ0EMUtvoRn0moXQxDMg5wzNJIreQHdsuX6vvk5BXhT9rm35YF26TM+9HgpSNNcNUkvHWw1PdyTMeK9twTrYabxNLGtsKIlIz475/w906M9eoezbqbGMk=;
X-YMail-OSG: oUe8PUkVM1ms7Qr3ZHbTs57yGUe3OXCAgKrLMlQ101BVTCcmZNyu1aVdTiT5OScG3aVfamcnAYhJ3xjny9tE0Y1YPTSbswvbZJbwiCATGpTpU3wJwoKYn.J57idvZkR5PKUfHsRQU8ej.C8p.6fhCHx.ZA--
Date: Wed, 15 Aug 2007 10:51:02 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Michael Tharp <gxti@partiallystapled.com>
Cc: alan <alan@clueserver.org>, linux-kernel@vger.kernel.org
In-Reply-To: <46C33835.90703@partiallystapled.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <121831.55601.qm@web52502.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Michael Tharp <gxti@partiallystapled.com> wrote:

> Marc Perkel wrote:
> > That not a problem - it's a feature. In such a
> > situation the person would get a general file
> creation
> > error.
> 
> Feature or not, it's still vulnerable to probing by
> malicious users. If
> there are create permissions on the directory, the
> invisibility is not
> perfect.

In a real world situation I would think that users
probing for invisible files is more secure that users
knowing the names of files that they have no access
to. 

> 
> > Although it isn't likely people would structure
> > files with invisible files in directories that the
> > user has create permissions [...]
> 
> ... /tmp ...

You're still thinking inside the box. Let's take the
tmp directory for example. /tmp wpuld probably g away
in favor of persomal /tmp directories. As we all know,
/tmp is the source of a lot of vulnerabilities.

One might put a name translation mask on the /tmp name
in the file name translation system. For example:

/tmp -> my /tmp

Thus files written to /tmp would become /mperkel/tmp
and users wouldn't be able to see other users /tmp
files or have any name conflicts.

Let me explain about the concept of thinking outside
the box. If you run into a problem you figure out a
new solution. It's about finding ways to make things
work rather than finding ways to make things not work.

So - we are not only talking about a name permission
system but a file name translation system. Thus a
user's view of the file system might not be the same
for all users. In fact, let's say that mperkel is a
Windows user and is just attacking to Linus as a file
system. Because mperkel is in the windows group the
file system appears as h:\home\mperkel on a native
Linux level and mounts are drive letters. It would use
a Windows name translation mask program that would be
part of the permission/naming system.




Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Sick sense of humor? Visit Yahoo! TV's 
Comedy with an Edge to see what's on, when. 
http://tv.yahoo.com/collections/222
