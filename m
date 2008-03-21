Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbYCUROs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbYCUROs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbYCUROg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:14:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36766 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbYCUROf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:14:35 -0400
Date: Fri, 21 Mar 2008 18:17:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST] [3/3] Replace macro recursion with more conventional loop
Message-ID: <20080321171724.GF2346@one.firstfloor.org>
References: <20080311223.655043226@firstfloor.org> <20080311012322.B1E221B41CE@basil.firstfloor.org> <alpine.LFD.1.00.0803211806590.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211806590.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 06:07:55PM +0100, Thomas Gleixner wrote:
> On Tue, 11 Mar 2008, Andi Kleen wrote:
> > The early exception handlers are currently set up using a macro
> > recursion. Replace that with a standard loop.
> > 
> > Noop patch, just a cleanup.
> 
> Cleanups before code changes please.

It relies on the earlier changes.

-Andi
