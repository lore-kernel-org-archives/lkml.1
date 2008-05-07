Return-Path: <linux-kernel-owner+w=401wt.eu-S1764980AbYEGS40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764980AbYEGS40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbYEGS4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:56:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822AbYEGS4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:56:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Soft lockup regression from today's sched.git merge.
Date: Wed, 7 May 2008 20:56:09 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <20080422.030519.259068348.davem@davemloft.net> <20080506.160508.58694844.davem@davemloft.net> <20080507064320.GC32195@elte.hu>
In-Reply-To: <20080507064320.GC32195@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805072056.10332.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of May 2008, Ingo Molnar wrote:
> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Date: Wed, 7 May 2008 00:41:01 +0200
> > 
> > > Can you please tell me what the current status of this is?
> > 
> > Group scheduling bug, fixed in Linus's tree already.
> 
> fixed by:

OK, thanks.

>  commit 3f5087a2bae5d1ce10a3d698dec8f879a96f5419
>  Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
>  Date:   Fri Apr 25 00:25:08 2008 +0200
> 
>      sched: fix share (re)distribution
> 
>      fix __aggregate_redistribute_shares() related lockup reported by
>      David S. Miller.
>  [...]
> 
> 	Ingo
