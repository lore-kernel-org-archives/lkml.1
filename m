Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbYDNWeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbYDNWeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYDNWdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:33:53 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:52180 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYDNWdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:33:52 -0400
Date: Mon, 14 Apr 2008 17:22:16 -0500
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/33 replaces 14/35 and 15/35] W1: w1_slave_read_id multiple short read bug
Message-ID: <20080414222216.GA15536@spacedout.fries.net>
References: <20080413225632.GA14058@spacedout.fries.net> <20080413231537.GF15213@spacedout.fries.net> <20080414114055.GA13385@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414114055.GA13385@2ka.mipt.ru>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 14 Apr 2008 17:22:17 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 03:40:55PM +0400, Evgeniy Polyakov wrote:
> Hi David.
> 
> On Sun, Apr 13, 2008 at 06:15:37PM -0500, David Fries (david@fries.net) wrote:
> > This is more to point out the bug in w1_slave_read_id, the next patch
> > rewrites the routine.
> > 
> > w1.c 1.15
> ... 
> > w1.c 1.16
> 
> 
> That is what I talked about. I agree with your analysis of the problem
> and I agree with fixes. But I do not agree with how you created them:
> why do we ever neen 1.15 version, since immediately after that we have
> 1.16 which completely rewrite what was done in previous one?
> This applies to the whole patchset: there are essentially several bug
> fixes and several features, so separate them into several patches, which
> do not collide with each other in the above way.

The old patch 14/35 and 15/35 was the only place I know of where I
fixed the bug, then replaced it wholesale with something better.
Several bugs, a few features, lots of patches, go figure.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
