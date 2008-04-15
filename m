Return-Path: <linux-kernel-owner+w=401wt.eu-S932595AbYDOVzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbYDOVzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYDOVzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:55:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbYDOVzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:55:41 -0400
Date: Tue, 15 Apr 2008 23:55:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415215504.GA9066@elte.hu>
References: <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080415211359.GA1531@elte.hu> <20080415212430.GA5467@elte.hu> <Pine.LNX.4.64.0804151437300.3252@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804151437300.3252@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 15 Apr 2008, Ingo Molnar wrote:
> 
> > btw., as i progress with that bisection effort, i triggered new crash 
> > patterns, which lappen later during bootup:
> 
> It may help to run with slub_debug (or CONFIG_SLUB_DEBUG_ON) then to 
> detect the corruption as early as possible. Only works if you get by 
> kmem_cache_init() though. Should give us some informative dumps of 
> what is exactly corrupted if it hits a slab object.

grumble. Do you read my bugreports?

CONFIG_SLUB_DEBUG=y
CONFIG_SLUB=y
CONFIG_SLUB_DEBUG_ON=y

	Ingo
