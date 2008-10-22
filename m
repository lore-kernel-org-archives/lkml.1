Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYJVWF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYJVWF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYJVWFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:05:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34221 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbYJVWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:05:51 -0400
Date: Thu, 23 Oct 2008 00:13:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alok Kataria <akataria@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is set.
Message-ID: <20081022221316.GW12825@one.firstfloor.org>
References: <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1> <20081021174008.GH12825@one.firstfloor.org> <1224612294.6161.43.camel@alok-dev1> <20081021181536.GI12825@one.firstfloor.org> <1224616236.6161.60.camel@alok-dev1> <20081021192746.GJ12825@one.firstfloor.org> <1224703427.13953.8.camel@alok-dev1> <20081022195845.GP12825@one.firstfloor.org> <1224712846.13953.37.camel@alok-dev1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224712846.13953.37.camel@alok-dev1>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Adding it with vmware detection code is not useful.
> 
> The VMware detection code is something that's needed anyways for other
> purposes(getting tsc_freq right now). So the code which force sets this
> TSC_CONSTANT bit is trivial.

It would be better to eliminate that too. Why do you need it anyways?

> Apart from that, as i said yesterday, this should be viewed as a special
> case for VMware products which don't already set this bit. Changing the
> behavior for already existing products is not feasible.

On old hypervisors Linux already runs fine without TSC, doesn't it?

-Andi
