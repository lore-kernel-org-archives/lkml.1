Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXKEMrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXKEMrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 07:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXKEMrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 07:47:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47547 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbXKEMrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 07:47:14 -0500
Subject: Re: oops in enqueue_entity with 2.6.24-rc1-g54866f03
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20071105124427.GA8765@alice>
References: <20071102123603.GA4988@alice> <1194266231.27652.437.camel@twins>
	 <20071105124427.GA8765@alice>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 13:47:12 +0100
Message-Id: <1194266832.27652.439.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-05 at 13:44 +0100, Eric Sesterhenn wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Fri, 2007-11-02 at 13:36 +0100, Eric Sesterhenn wrote:
> > > hi,
> > > 
> > > I get the following crash with 2.6.24-rc1-g54866f03, the last version I
> > > tested which booted fine was 2.6.24-rc1-gb1d08ac0
> > > 
> > 
> > How reproducable is this?
> 
> happens every boot
> 
> > If its very much reproducable, could you git bisect it, as in between
> > those commits you tested nothing much has changed, that is, nothing that
> > stands out to me.
> 
> i did already bisect this but landed at a commit which wasnt the cause
> (also failed when i reverted it), I am currently bisecting a second time with
> -rc1 as the other starting point, because I am not sure how to make git
> give me revision gb1d08ac0 again to test it another time (the binary i
> have here boots fine)

git checkout b1d08ac0

should do I guess.

