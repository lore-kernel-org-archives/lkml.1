Return-Path: <linux-kernel-owner+w=401wt.eu-S1764491AbYDOFoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764491AbYDOFoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 01:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYDOFoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 01:44:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57445 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbYDOFoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 01:44:07 -0400
Date: Tue, 15 Apr 2008 07:43:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at
	mm/slab.c:2103!"
Message-ID: <20080415054334.GA7420@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080411092452.GE10801@elte.hu> <Pine.LNX.4.64.0804111228100.20334@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804111228100.20334@schroedinger.engr.sgi.com>
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

> On Fri, 11 Apr 2008, Ingo Molnar wrote:
> 
> > if this is a zone setup bug then a sanity-check could catch it right 
> > where it happens - not much later in the slab code or so.
> 
> Could you post the zone setup of the system that fails? A memory map 
> would be useful and full dmesg output up to the failure.

it's all in my bugreport you are replying to:

   http://lkml.org/lkml/2008/4/11/34

it's a full dmesg up to the failure, which starts with the memory map of 
the system ...

	Ingo
