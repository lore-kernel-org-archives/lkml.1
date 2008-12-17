Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753520AbYLQXV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYLQXV6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYLQXVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:21:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37495 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbYLQXVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:21:42 -0500
Date: Thu, 18 Dec 2008 00:33:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: FPU emulation broken in 2.6.28-rc8 ?
Message-ID: <20081217233357.GI25779@one.firstfloor.org>
References: <20081217085620.GA20184@bitwizard.nl> <20081217203227.GA10899@bitwizard.nl> <878wqe1kvg.fsf@basil.nowhere.org> <20081217225221.GA6247@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217225221.GA6247@bitwizard.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 11:52:21PM +0100, Rogier Wolff wrote:
> On Wed, Dec 17, 2008 at 11:45:39PM +0100, Andi Kleen wrote:
> > Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
> > >> 
> > >> I'm trying to set up a thin client, which runs on a geode, which
> > >> apparently doesn't have a FPU.... (/proc/cpuinfo mentions the flag 
> > >> "fpu", what does THAT mean?)
> > 
> > Geodes all have FPUs to my knowledge.
> > The only FPU less x87s are 386s and special 486s (and a few emulators)
> > 
> > If the FPU doesn't work on the Geode something else must be broken
> > (or your CPU is not really a Geode)
> 
> Although the /proc/cpuinfo file shows the FPU flag, the kernel stops
> with "no fpu found, and math emulation not present" if I disable
> FP emulation.... 

As I said then the problem is likely with the FPU check.

That said I don't doubt that FPU emulation might have broken
again (that is because hardly anyone uses it), just that fixing
it is not the real fix for your problem.

-Andi
