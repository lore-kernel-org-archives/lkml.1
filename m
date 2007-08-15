Return-Path: <linux-kernel-owner+w=401wt.eu-S964824AbXHOUpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbXHOUpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXHOUox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:44:53 -0400
Received: from web52506.mail.re2.yahoo.com ([206.190.48.189]:39592 "HELO
	web52506.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751328AbXHOUow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:44:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=dwGP4xgMSeldjkCckHO1fAqVdmT+lbiBlZlYD2uzNrQBl7XFG0xz/dg5+/ljUiDNRPL3qgSe/zSEcdlm46P6tcM9kjd6jW/OT2FiE4QVvsWkeUtXAmxYZ5cW6ex/N1kQQfy/V7JDKqWwhM2qyE5vA6GEZUa7feQ3Jclnj/rLN1A=;
X-YMail-OSG: Uzf.ClwVM1k9k3PrWTryJIqgdMdhGs0AtQymFSU6JATrciX7QCoMHX3etAW7UPXEHXGZsne9RIAt0DDcMwai2fqZMdC009INiBn0nDiqRK2dRnYYZSxYk5Yn8tSt0gE9vLKvyp04DSmqEdu4VkekAQ0j
Date: Wed, 15 Aug 2007 13:44:50 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Marc Perkel <mperkel@yahoo.com>, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, LKML Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <7B9C0CB2-7CE6-49E4-8F28-BBA96B1821B6@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <126267.7876.qm@web52506.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Aug 15, 2007, at 15:26:07, Lennart Sorensen
> wrote:
> > On Wed, Aug 15, 2007 at 10:59:12AM -0700, Marc
> Perkel wrote:
> >> When one thinks outside the box one has to think
> about evolving  
> >> beyond what you are used to. When I moved
> >> beyond DOS I have to give up the idea of 8.3 file
> names. The idea  
> >> here is to come up with a model that can emulate
> the existing  
> >> system for backwards compatibility.
> >
> > But moving beyond 8.3 didn't prevent you from
> still using 8.3 names  
> > if you wanted too.  Longer file names are just an
> extension of  
> > shorter ones.
> 
> As another example, take a look at "git", the SCM we
> use for the  
> kernel, as contrasted with the older CVS.  You can
> import your  
> complete CVS history into it without data loss, and
> then you can even  
> continue to use it the exact same way you used to
> use CVS, with some  
> slight differences in command-line syntax.  Once you
> are ready to  
> move further, though, you can create multiple local
> branches to have  
> your co-workers pull from to test changes.  You
> discover that merging  
> branches is much easier in git than in CVS.  Your
> company starts to  
> use a more distributed development model, they
> implement a policy  
> telling developers to break up their changes into
> smaller pieces and  
> write better change-logs.  Somebody suddenly
> discovers the ability to  
> "sign" a particular release version with a private
> key, and you start  
> doing that as part of your release management to
> ensure that the  
> codebase marked with a client tag is the exact same
> one you actually  
> shipped to that client.
> 
> On a fundamental level, GIT is a completely
> different paradigm from  
> CVS.  Its internal operations are entirely
> differently organized, it  
> uses different algorithms and different storage
> formats.  The end  
> result of that is that it's literally orders of
> magnitude faster on  
> large codebases.  But to the USER it can be used
> exactly the same;  
> you could even write a little CVS-to-GIT wrapper
> which imported your  
> CVS into a git repo and then let you operate on it
> using "gcvs"  
> commands the same way you would have operated on
> real CVS repositories.
> 
> Just some food for thought
> 
> Cheers,
> Kyle Moffett
> 


Yes - that's a good example. Git is far more powerful
and a different paradigm for CVS. Someone had to think
outside the box and come up with a new way of looking
at things. I'm trying to do something like that with
this idea.

To me it make more sense to get rid of file
permissions and look at people permissions. It reminds
me of a story a friend of mine told about her 4 year
old son.

The story was that they were driving down the road
when they saw a wheel come off a truck. The son said,
"look mommy, that wheel lost it's truck."

To me files are like the wheel. Rather than having the
file know all it's owners it makes more sense for the
owners to know it's files.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
