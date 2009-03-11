Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZCKPJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZCKPJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZCKPJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:09:36 -0400
Received: from www.tglx.de ([62.245.132.106]:43753 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZCKPJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:09:36 -0400
Date: Wed, 11 Mar 2009 16:08:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 1/2] x86: unify kmap_atomic_pfn() and
 iomap_atomic_prot_pfn()
In-Reply-To: <20090311143317.GA22244@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903111606350.29264@localhost.localdomain>
References: <20090311143317.GA22244@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Akinobu Mita wrote:
> kmap_atomic_pfn() and iomap_atomic_prot_pfn() are almost same except
> pgprot. This patch removes the code duplication for these two functions.

How exaclty does this compile with CONFIG_HIGHMEM=n ?
 
Thanks,

	tglx
