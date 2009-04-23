Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbZDWNzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbZDWNzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZDWNze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:55:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:54173 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZDWNze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:55:34 -0400
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-Id: <34687519-FB41-4447-9575-68EB1DC2D3EC@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20090423225611.d569764c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH v2] powerpc: fix for long standing bug noticed by gcc 4.4.0
Date: Thu, 23 Apr 2009 08:55:12 -0500
References: <20090423160656.fac84e3f.sfr@canb.auug.org.au> <20090423103336.GA3825@zod.rchland.ibm.com> <20090423225611.d569764c.sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 23, 2009, at 7:56 AM, Stephen Rothwell wrote:

> Previous gcc versions didn't notice this because one of the preceding
> #ifs always evaluated to true.
>
> gcc 4.4.0 produced this error:
>
> arch/powerpc/mm/tlb_nohash_low.S:206:6: error: #elif with no  
> expression
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> ---
> arch/powerpc/mm/tlb_nohash_low.S |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> v2: fixed up commit message, added Josh'd Ack.

applied to merge.  Picking this up as I'm touching tlb_nohash_low.S w/ 
another "fix".

- k
