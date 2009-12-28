Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZL1Xhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZL1Xhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZL1Xhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:37:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43513 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZL1Xhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:37:37 -0500
Date: Tue, 29 Dec 2009 00:37:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net,
       Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, mort@sgi.com,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 05/37] kdb: core for kgdb back end
Message-ID: <20091228233734.GA15175@basil.fritz.box>
References: <87y6ktb1p5.fsf@basil.nowhere.org> <4B3932D3.8020608@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3932D3.8020608@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 04:36:03PM -0600, Jason Wessel wrote:
> Andi Kleen wrote:
> > Jason Wessel <jason.wessel@windriver.com> writes:
> > 
> > I remember going with kaos through all the code
> > outside kdb/ in his own patch and for nearly all hooks
> > outside we found some way to eliminate them. 
> > 
> > I think a lot of this is here too.
> 
> 
> If this has been solved before somewhere, please point me in that direction.  There are whole lot few changes in this series vs original kdb outside of the kdb core area.

I don't think we ever generated patches, just reviewed all the changes
outside kdb/* and eventually agreed that it wasn't needed or could be done in a much
cleaner way.

Frankly some things can be also just dropped. Or if you're really desperate
about nops just nop the spinlock functions while kdb runs.

-Andi
