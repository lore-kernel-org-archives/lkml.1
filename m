Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbZHVTPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbZHVTPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 15:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933312AbZHVTPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 15:15:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933310AbZHVTPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 15:15:46 -0400
Date: Sat, 22 Aug 2009 12:15:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI fix
In-Reply-To: <20090822120448.2e36bb93@jbarnes-g45>
Message-ID: <alpine.LFD.2.01.0908221214370.3158@localhost.localdomain>
References: <20090822120448.2e36bb93@jbarnes-g45>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Aug 2009, Jesse Barnes wrote:
>
> Just one fix here that turns out to fix a suspend/resume regression.  It is a
> core change though, and I'm a little nervous about pushing it at this point.
> So feel free to ignore it if you think it's too risky; we can always land it
> in 2.6.31.1 during the merge window instead (to get it a little more coverage
> first).

The patch looks so trivially correct that I have no qualms about taking 
it.

Not that "trivially correct" code hasn't triggered latent bugs before, but 
if it's known to fix a regressio I think this is a no-brainer. So pulled,

		Linus
