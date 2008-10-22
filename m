Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYJVUK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYJVUK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbYJVUKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:10:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42626 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbYJVUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:10:17 -0400
Date: Wed, 22 Oct 2008 22:17:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alok Kataria <akataria@vmware.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is set.
Message-ID: <20081022201743.GR12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1> <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1> <20081021174008.GH12825@one.firstfloor.org> <1224612294.6161.43.camel@alok-dev1> <20081021181536.GI12825@one.firstfloor.org> <1224616236.6161.60.camel@alok-dev1> <20081021192746.GJ12825@one.firstfloor.org> <1224703427.13953.8.camel@alok-dev1> <20081022192622.GA30930@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022192622.GA30930@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the sync check is there to check the _offset_ between CPUs. CONSTANT_TSC 
> is not a guarantee that the TSC will be coherent across all CPUs.

I cannot find a quote for it in the docs now, but iirc the AMD 
definition of the bit guarantees offset, aka full synchronization
over the system.

-Andi
