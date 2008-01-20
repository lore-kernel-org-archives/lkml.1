Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYATDIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYATDIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 22:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYATDI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 22:08:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40466 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYATDI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 22:08:29 -0500
Date: Sun, 20 Jan 2008 04:11:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080120031153.GB6275@one.firstfloor.org>
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4792B191.2060801@davidnewall.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 12:57:29PM +1030, David Newall wrote:
> Andi Kleen wrote:
> > Can you please queue this patch in -mm for .25. It was posted earlier
> > and nobody complained.
> 
> I'm sure I complained.  I'm sure I said something about SCO

Did you? 

> compatibility.  This is a sleeping giant for Linux.  There are plenty of

Interesting choice of words.

> machines running legacy SCO applications, just waiting for painless
> migration to some other platform.
> 
> We should not be dismantling the scaffolding that's needed for that.

See the rationale in the patch -- any iBCS application will need a significant
kernel patch. If people add this kernel patch they can easily patch the three
more places that detect the executables.

But it does not make sense for all Linux kernels to always check for iBCS executables
when they don't have to code to run them anyways.

Now if iBCS support is truly as important as you claim I'm sure
someone will eventually submit a patch for mainline to support it properly.
If yes the hooks can be readded in a clean way, not in a hackish way
like they currently exists.

-Andi

> 
