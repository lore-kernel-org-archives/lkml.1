Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbXLGTG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbXLGTG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXLGTGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:06:45 -0500
Received: from [212.12.190.22] ([212.12.190.22]:43159 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752165AbXLGTGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:06:44 -0500
From: Al Boldi <a1426z@gawab.com>
To: Jakub Narebski <jnareb@gmail.com>
Subject: Re: git guidance
Date: Fri, 7 Dec 2007 22:04:48 +0300
User-Agent: KMail/1.5
Cc: Andreas Ericsson <ae@op5.se>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>,
       Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com> <200712071353.11654.a1426z@gawab.com> <m3prxiu3oo.fsf@roke.D-201>
In-Reply-To: <m3prxiu3oo.fsf@roke.D-201>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712072204.48410.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Narebski wrote:
> Al Boldi <a1426z@gawab.com> writes:
> > For example:
> >
> >   echo "// last comment on this file" >> /gitfs.mounted/file
> >
> > should do an implied checkpoint, and make these checkpoints immediately
> > visible under some checkpoint branch of the gitfs mounted dir.
> >
> > Note, this way the developer gets version control without even noticing,
> > and works completely transparent to any kind of application.
>
> Why not use versioning filesystem for that, for example ext3cow
> (which looks suprisingly git-like, when you take into account that
> for ext3cow history is linear and centralized, so one can use date
> or sequential number to name commits).
>
> See GitLinks page on Git Wiki, "Other links" section:
>   http://www.ext3cow.com/

Sure, Linus mentioned the cow idea before in this thread, but you would still 
need a few hacks to get some basic Version Control features.  

> Version control system is all about WORKFLOW B, where programmer
> controls when it is time to commit (and in private repository he/she
> can then rewrite history to arrive at "Perfect patch series"[*1*]);
> something that for example CVS failed at, requiring programmer to do
> a merge if upstream has any changes when trying to commit.

Because WORKFLOW C is transparent, it won't affect other workflows.  So you 
could still use your normal WORKFLOW B in addition to WORKFLOW C, gaining an 
additional level of version control detail at no extra cost other than the 
git-engine scratch repository overhead.

BTW, is git efficient enough to handle WORKFLOW C?


Thanks!

--
Al

