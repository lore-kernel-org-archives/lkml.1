Return-Path: <linux-kernel-owner+w=401wt.eu-S933269AbYDOWN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbYDOWN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbYDOWNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:13:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44974 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873AbYDOWNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:13:48 -0400
Date: Wed, 16 Apr 2008 00:13:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415221314.GA12094@elte.hu>
References: <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080415211359.GA1531@elte.hu> <20080415212430.GA5467@elte.hu> <Pine.LNX.4.64.0804151437300.3252@schroedinger.engr.sgi.com> <20080415215504.GA9066@elte.hu> <Pine.LNX.4.64.0804151455520.4038@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804151455520.4038@schroedinger.engr.sgi.com>
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

> Trying to duplicate the issue here.
> 
> Boot with PAE support on a machine with 8G RAM 8 processors here works 
> fine.

have you tried my config on that box? Check:

  http://redhat.com/~mingo/misc/config-Thu_Apr_10_10_41_16_CEST_2008.bad.rc9

	Ingo
