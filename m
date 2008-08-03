Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbYHCO6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbYHCO6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbYHCO6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:58:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:47278 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbYHCO6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:58:37 -0400
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, ppc-dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rdreier@cisco.com>,
       general@lists.openfabrics.org
Message-Id: <A5259752-468C-4CBA-BEF3-4E088ED1A5B9@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
In-Reply-To: <20080801152030.ff10b6b2.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH v2] powerpc: move include files to arch/powerpc/include/asm
Date: Sun, 3 Aug 2008 09:58:14 -0500
References: <20080801152030.ff10b6b2.sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1, 2008, at 12:20 AM, Stephen Rothwell wrote:

> from include/asm-powerpc.  This is the result of a
>
> mkdir arch/powerpc/include/asm
> git mv include/asm-powerpc/* arch/powerpc/include/asm
>
> Followed by a few documentation/comment fixups and a couple of places
> where <asm-powepc/...> was being used explicitly.  Of the latter only
> one was outside the arch code and it is a driver only built for  
> powerpc.
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>
> v2 don't change other arch files - the fixups are only in comments  
> anyway.
>
> This patch can be applied with "git am" - the full patch is way to bug
> for our mailing lists.
>
> This has been built for all the powerpc defconfigs including
> all{no,mod,yes}config.  There was only one failure, but that is
> expected anyway (I had to apply patches for the iommu and hfcmulti
> breakages).

Paul, what's the plan for this change?  If this is something that will  
go in so can we get a tree with it so we can base other patches on it  
(like the PPC_MERGE cleanup)?

- k
