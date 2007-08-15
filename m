Return-Path: <linux-kernel-owner+w=401wt.eu-S934963AbXHOUML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963AbXHOUML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbXHOUL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:11:59 -0400
Received: from smtpout.mac.com ([17.250.248.171]:53128 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522AbXHOUL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:11:58 -0400
In-Reply-To: <20070815192607.GE9410@csclub.uwaterloo.ca>
References: <F38DAAD2-D984-4704-94AC-5FB963C4373C@mac.com> <631385.29200.qm@web52512.mail.re2.yahoo.com> <20070815192607.GE9410@csclub.uwaterloo.ca>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7B9C0CB2-7CE6-49E4-8F28-BBA96B1821B6@mac.com>
Cc: Marc Perkel <mperkel@yahoo.com>, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, LKML Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Wed, 15 Aug 2007 16:11:44 -0400
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2007, at 15:26:07, Lennart Sorensen wrote:
> On Wed, Aug 15, 2007 at 10:59:12AM -0700, Marc Perkel wrote:
>> When one thinks outside the box one has to think about evolving  
>> beyond what you are used to. When I moved
>> beyond DOS I have to give up the idea of 8.3 file names. The idea  
>> here is to come up with a model that can emulate the existing  
>> system for backwards compatibility.
>
> But moving beyond 8.3 didn't prevent you from still using 8.3 names  
> if you wanted too.  Longer file names are just an extension of  
> shorter ones.

As another example, take a look at "git", the SCM we use for the  
kernel, as contrasted with the older CVS.  You can import your  
complete CVS history into it without data loss, and then you can even  
continue to use it the exact same way you used to use CVS, with some  
slight differences in command-line syntax.  Once you are ready to  
move further, though, you can create multiple local branches to have  
your co-workers pull from to test changes.  You discover that merging  
branches is much easier in git than in CVS.  Your company starts to  
use a more distributed development model, they implement a policy  
telling developers to break up their changes into smaller pieces and  
write better change-logs.  Somebody suddenly discovers the ability to  
"sign" a particular release version with a private key, and you start  
doing that as part of your release management to ensure that the  
codebase marked with a client tag is the exact same one you actually  
shipped to that client.

On a fundamental level, GIT is a completely different paradigm from  
CVS.  Its internal operations are entirely differently organized, it  
uses different algorithms and different storage formats.  The end  
result of that is that it's literally orders of magnitude faster on  
large codebases.  But to the USER it can be used exactly the same;  
you could even write a little CVS-to-GIT wrapper which imported your  
CVS into a git repo and then let you operate on it using "gcvs"  
commands the same way you would have operated on real CVS repositories.

Just some food for thought

Cheers,
Kyle Moffett
