Return-Path: <linux-kernel-owner+w=401wt.eu-S1764907AbXHORJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764907AbXHORJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXHORJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:09:33 -0400
Received: from web52512.mail.re2.yahoo.com ([206.190.48.195]:24496 "HELO
	web52512.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751962AbXHORJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:09:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3Tb370GwmKCmHUFIAGK4BFVU0ram2obcRRr8n9Wv3F0BknURbzsuzQ6QGZba8zCjDY60QLVGjrlyr3zJ9VZo0+aaQCtAS7noOgIWmvXVY9pjVD2AscoBdJfd7T9djvfUNaGx6JDfwnCduaRXLYztDsiUnaO2trFvv3+YUP8pTgU=;
X-YMail-OSG: Vblo5xsVM1lmcXeMRzx8Xr9LOSO4xYQNFKWFIVa9rLfh17EuVKIyCyKx529DnF34XBW8Kcs0mAgzA2HdLsQ8CBncQIQkd.fe9wdZqnluCzXZX31PsBwljxy0McUvbg--
Date: Wed, 15 Aug 2007 10:09:31 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Valdis.Kletnieks@vt.edu
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <19705.1187197065@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <763705.7247.qm@web52512.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Valdis.Kletnieks@vt.edu wrote:

> On Wed, 15 Aug 2007 09:02:41 PDT, Marc Perkel said:
> 
> > Kyle, thinking further outside the box, files
> would no
> > longer have owners or permissions. Nor would
> > directories. People, groups, managers, and other
> > objects with have permissions.
> 
> You gotta think *way* out of the box to come up with
> a system where a "file"
> isn't an object that can have some sort of ACL or
> permissions on it.
> 


Yep - way outside the box - and thus the title of the
thread.

The idea is that people have permissions - not files.
By people I mean users, groups, managers, applications
etc. One might even specify that there are no
permission restrictions at all. Part of the process
would be that the kernel load what code it will use
for the permission system. It might even be a little
perl script you write.


Also - you aren't even giving permission to access
files. It's permission to access name patterns. One
could apply REGEX masks to names to determine
permissions. So if you have permission to the name you
have permission to the file.

Hard links would be multiple names pointing to the
same file. Simlinks would be name aliases.



Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/  
