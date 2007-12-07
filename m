Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXLFRhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXLFRhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbXLFRg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:36:58 -0500
Received: from [212.12.190.133] ([212.12.190.133]:49234 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751378AbXLFRg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:36:57 -0500
From: Al Boldi <a1426z@gawab.com>
To: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: git guidance
Date: Fri, 7 Dec 2007 20:35:47 +0300
User-Agent: KMail/1.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com> <200712010950.15628.a1426z@gawab.com> <4755D2E8.5050402@cfl.rr.com>
In-Reply-To: <4755D2E8.5050402@cfl.rr.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712072035.47359.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Al Boldi wrote:
> > IOW, git currently only implements the server-side use-case, but fails
> > to deliver on the client-side.  By introducing a git-client manager that
> > handles the transparency needs of a single user, it should be possible
> > to clearly isolate update semantics for both the client and the server,
> > each handling their specific use-case.
>
> Any talk of client or server makes no sense since git does not use a
> client/server model.

Whether git uses the client/server model or not does not matter; what matters 
is that there are two distinct use-cases at work here:  one on the 
server/repository, and the other on the client.  

> If you wish to use a centralized repository, then
> git can be set up to transparently push/pull to/from said repository if
> you wish via hooks or cron jobs.

Again, this only handles the interface to/from the server/repository, but 
once you pulled the sources, it leaves you without Version Control on the 
client.

By pulling the sources into a git-client manager mounted on some dir, it 
should be possible to let the developer work naturally/transparently in a 
readable/writeable manner, and only require his input when reverting locally 
or committing to the server/repository.


Thanks!

--
Al

