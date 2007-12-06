Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbXLFS5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbXLFS5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXLFS5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:57:25 -0500
Received: from mail.op5.se ([193.201.96.20]:55749 "EHLO mail.op5.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbXLFS5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:57:24 -0500
X-Greylist: delayed 1976 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2007 13:57:24 EST
X-Spam-Flag: NO
X-Spam-Score: -2.499
Message-ID: <47583E57.9050208@op5.se>
Date: Thu, 06 Dec 2007 19:24:23 +0100
From: Andreas Ericsson <ae@op5.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: git guidance
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com> <200712010950.15628.a1426z@gawab.com> <4755D2E8.5050402@cfl.rr.com> <200712072035.47359.a1426z@gawab.com>
In-Reply-To: <200712072035.47359.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Phillip Susi wrote:
>> Al Boldi wrote:
>>> IOW, git currently only implements the server-side use-case, but fails
>>> to deliver on the client-side.  By introducing a git-client manager that
>>> handles the transparency needs of a single user, it should be possible
>>> to clearly isolate update semantics for both the client and the server,
>>> each handling their specific use-case.
>> Any talk of client or server makes no sense since git does not use a
>> client/server model.
> 
> Whether git uses the client/server model or not does not matter; what matters 
> is that there are two distinct use-cases at work here:  one on the 
> server/repository, and the other on the client.  
> 

Git is distributed. The repository is everywhere. No server is actually needed.
Many use one anyway since it can be convenient. It's not, however, necessary.

>> If you wish to use a centralized repository, then
>> git can be set up to transparently push/pull to/from said repository if
>> you wish via hooks or cron jobs.
> 
> Again, this only handles the interface to/from the server/repository, but 
> once you pulled the sources, it leaves you without Version Control on the 
> client.
> 

No, that's CVS, SVN and other centralized scm's. With git you have perfect
version control on each peer. That's the entire idea behind "fully
distributed".

> By pulling the sources into a git-client manager mounted on some dir, it 
> should be possible to let the developer work naturally/transparently in a 
> readable/writeable manner, and only require his input when reverting locally 
> or committing to the server/repository.
> 

How is that different from what every SCM, including git, is doing today? The
user needs to tell the scm when it's time to take a snapshot of the current
state. Git is distributed though, so committing is usually not the same as
publishing. Is that lack of a single command to commit and publish what's
nagging you? If it's not, I completely fail to see what you're getting at,
unless you've only ever looked at repositories without a worktree attached,
or you think that git should work like an editor's "undo" functionality,
which would be quite insane.

-- 
Andreas Ericsson                   andreas.ericsson@op5.se
OP5 AB                             www.op5.se
Tel: +46 8-230225                  Fax: +46 8-230231
