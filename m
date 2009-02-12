Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbZBLBrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbZBLBrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbZBLBrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:47:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48072
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758244AbZBLBrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:47:40 -0500
Date: Wed, 11 Feb 2009 17:47:33 -0800 (PST)
Message-Id: <20090211.174733.163367216.davem@davemloft.net>
To: npiggin@suse.de
Cc: penberg@cs.helsinki.fi, sachinp@in.ibm.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: next Feb 10: mm/slqb build break
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090212014503.GD30043@wotan.suse.de>
References: <49914EE7.7030205@in.ibm.com>
	<84144f020902100353x4074f342ne4d61483074a06b7@mail.gmail.com>
	<20090212014503.GD30043@wotan.suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Thu, 12 Feb 2009 02:45:03 +0100

> On Tue, Feb 10, 2009 at 01:53:51PM +0200, Pekka Enberg wrote:
> > Actually, that's not the root cause here. You seem to have CONFIG_SMP
> > disabled but CONFIG_NUMA enabled. That's not possible on x86 which
> > makes me think it's a ppc kconfig bug. Hmm?
> 
> If it is really a valid config, then we should be able to make
> slqb build with it...

FWIW I only allow NUMA with SMP on sparc64, just like x86.

Although it seems IA64, like powerpc, does not have this restriction.
Hmmm...
