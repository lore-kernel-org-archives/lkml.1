Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbYDCV3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbYDCV3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbYDCV30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:29:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34188 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbYDCV3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:29:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: Regression in gdm-2.18 since 2.6.24
Date: Thu, 3 Apr 2008 23:29:21 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
References: <20080403191916.GA30864@deepthought> <200804032156.54021.rjw@sisk.pl> <20080403210840.GA2292@deepthought>
In-Reply-To: <20080403210840.GA2292@deepthought>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804032329.22483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of April 2008, Ken Moffat wrote:
> On Thu, Apr 03, 2008 at 09:56:53PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, 3 of April 2008, Ken Moffat wrote:
> > >  Third attempt, with luck this time I've managed to find what really
> > > broke it.  Sorry, this is going to be a long mail to explain my
> > > current attribution of 'blame'.
> [...]
> > 
> > The attachments are missing.
> > 
> > Can you please just provide us with the name of the git commit that you think
> > breaks things for you?
> > 
> > Also, is there CONFIG_FAIR_GROUP_SCHED set in your .config?
> > 
> > Thanks,
> > Rafael
>  Oh!  Maybe they are there this time.  Apologies.
> 
>  For the commit, all I've got is the truncated line out of
> patch-2.6.24.1:
> index da7c061..2288ad8 100644
> 
>  Unfortunately, git log doesn't seem to find da7c061.
> 
>  And from the config
> CONFIG_FAIR_GROUP_SCHED=y

Please unset CONFIG_GROUP_SCHED and retest.  It is known to cause problems
(see http://bugzilla.kernel.org/show_bug.cgi?id=9969, for example).

Thanks,
Rafael
