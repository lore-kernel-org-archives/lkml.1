Return-Path: <linux-kernel-owner+w=401wt.eu-S1765109AbYEATEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765109AbYEATEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762350AbYEATEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:04:30 -0400
Received: from 1wt.eu ([62.212.114.60]:3694 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762291AbYEATE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:04:29 -0400
Date: Thu, 1 May 2008 21:03:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501190358.GC30883@1wt.eu>
References: <20080429.190352.137408408.davem@davemloft.net> <20080501055045.GC18597@1wt.eu> <200805011353.19335.rjw@sisk.pl> <200805011516.43159.bzolnier@gmail.com> <2c0942db0805010829r50ea361ja9e62a33991dc640@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0805010829r50ea361ja9e62a33991dc640@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 08:29:18AM -0700, Ray Lee wrote:
> And as a policy suggestion, if we're past rc1 and someone has
> identified a commit as the root of a regression/bug, then the policy
> should be just to revert it immediately, no questions asked. Let the
> original author work with the person who identified the problem and
> resend a fixed commit later. We lose testers in the meantime, and
> perhaps the extra effort involved in having the author work out the
> issues and redo the patch will help prevent drive-by patching in the
> future.

you make a valid point here : "we lose testers in the meantime". Maybe
it would help if -rc2 would be released a few days after -rc1 with
the first most obvious showstoppers (often build issues). The most
problematic ones are often fixed within an hour or so, but for most
testers, it still means they have to wait for -rc2.

Most external testers might then only try -rc2 first, but that's not
a problem. What we really want is them to test widely and not revert
back at the first problem. If only 20% of testers try -rc1, and the
remaining 80% actively wait for -rc2 3 days after, then we'll get
broader testing in the first two weeks.

Willy

