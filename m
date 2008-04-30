Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbYD3Wxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbYD3Wxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYD3Wxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:53:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbYD3Wxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:53:35 -0400
Date: Wed, 30 Apr 2008 15:52:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080430155252.76469ead.akpm@linux-foundation.org>
In-Reply-To: <20080430224610.GO8474@1wt.eu>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302245.50817.rjw@sisk.pl>
	<alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org>
	<200805010023.32213.rjw@sisk.pl>
	<alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
	<20080430224610.GO8474@1wt.eu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 00:46:10 +0200
Willy Tarreau <w@1wt.eu> wrote:

> On Wed, Apr 30, 2008 at 03:31:22PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> > > 
> > > > And there's no way to avoid the fact that during the merge window, we will 
> > > > get something on the order of ten thousand commits (eg 2.6.24->25-rc1 was 
> > > > 9629 commits).
> > > 
> > > Well, do we _have_ _to_ take that much?  I know we _can_, but is this really
> > > necessary?
> > 
> > Do you want me to stop merging your code?
> > 
> > Do you think anybody else does?
> > 
> > Any suggestions on how to convince people that their code is not worth 
> > merging?
> 
> I think you're approaching a solution Linus. If developers take a refusal
> as a punishment, maybe you can use that for trees which have too many
> unresolved regressions. This would be really unfair to subsystem maintainers
> which themselves merge a lot of work, but recursively they may apply the
> same principle to their own developers, so that everybody knows that it's
> not worth working on next code past a point where too many regressions are
> reported.
> 

Well.  If we were good enough at tracking bug reports and regressions we
could look at the status of subsytem X and say "no new features for you".

That would be a drastic step even if we had the information to do it (which
we don't).

It would certainly put the pigeon amongst the cats tho.
