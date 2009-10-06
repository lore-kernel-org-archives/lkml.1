Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbZJFKXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbZJFKXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbZJFKXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:23:42 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:65492 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844AbZJFKXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:23:42 -0400
From: Frans Pop <elendil@planet.nl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Tue, 6 Oct 2009 12:23:01 +0200
User-Agent: KMail/1.9.9
Cc: Mel Gorman <mel@csn.ul.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>, linux-mm@kvack.org
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910052334.23833.elendil@planet.nl> <alpine.DEB.1.00.0910051700440.31688@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0910051700440.31688@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061223.04293.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 10:23:05.0704 (UTC) FILETIME=[FE1B7680:01CA466E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009, David Rientjes wrote:
> On Mon, 5 Oct 2009, Frans Pop wrote:
> > And the winner is:
> > 2ff05b2b4eac2e63d345fc731ea151a060247f53 is first bad commit
> > commit 2ff05b2b4eac2e63d345fc731ea151a060247f53
> > Author: David Rientjes <rientjes@google.com>
> > Date:   Tue Jun 16 15:32:56 2009 -0700
> >
> >     oom: move oom_adj value from task_struct to mm_struct
> >
> > I'm confident that the bisection is good. The test case was very
> > reliable while zooming in on the merge from akpm.
>
> I doubt it for two reasons: (i) this commit was reverted in 0753ba0
> since 2.6.31-rc7 and is no longer in the kernel, and (ii) these are
> GFP_ATOMIC allocations which would be unaffected by oom killer scores.

OK. Looks like I have been getting some false "good" results. I've been 
redoing part of the bisect and am getting close to a new candidate. Will 
explain further when I have that.

Cheers,
FJP
