Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYBKPgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYBKPgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYBKPfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:35:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45918 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbYBKPfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:35:51 -0500
Date: Mon, 11 Feb 2008 17:11:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: kgdb in git-x86#mm review
Message-ID: <20080211161114.GA19537@one.firstfloor.org>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mhcgf4ig1.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 10:32:46AM -0500, Frank Ch. Eigler wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> > [...]  The kgdb code in git-x86#mm is right now is totally broken of
> > course because the CFI annotations in assembler code are gone now,
> > but they are needed for gdb use.  [...]
> 
> This loss of CFI data is unfortunate for other potential consumers
> too, such as systemtap, which intends to supplement its current stack
> backtracing heuristics with CFI data.

They seem to have reverted these patches now, so that problem 
is gone.

Yes there are a couple of other consumers of CFI too, like crash
or the out of tree (but not dead) in kernel unwinder.

-Andi
