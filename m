Return-Path: <linux-kernel-owner+w=401wt.eu-S1762670AbYD3Wqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762670AbYD3Wqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYD3Wqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:46:38 -0400
Received: from 1wt.eu ([62.212.114.60]:3638 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYD3Wqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:46:38 -0400
Date: Thu, 1 May 2008 00:46:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080430224610.GO8474@1wt.eu>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 03:31:22PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> > 
> > > And there's no way to avoid the fact that during the merge window, we will 
> > > get something on the order of ten thousand commits (eg 2.6.24->25-rc1 was 
> > > 9629 commits).
> > 
> > Well, do we _have_ _to_ take that much?  I know we _can_, but is this really
> > necessary?
> 
> Do you want me to stop merging your code?
> 
> Do you think anybody else does?
> 
> Any suggestions on how to convince people that their code is not worth 
> merging?

I think you're approaching a solution Linus. If developers take a refusal
as a punishment, maybe you can use that for trees which have too many
unresolved regressions. This would be really unfair to subsystem maintainers
which themselves merge a lot of work, but recursively they may apply the
same principle to their own developers, so that everybody knows that it's
not worth working on next code past a point where too many regressions are
reported.

Willy

