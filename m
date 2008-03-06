Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbYCFQJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbYCFQJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYCFQJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:09:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:56459 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbYCFQJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:09:36 -0500
Date: Thu, 6 Mar 2008 19:09:18 +0300
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [POWERPC] 8xx: fix swap
Message-ID: <20080306190918.04e2cee6@kernel.crashing.org>
In-Reply-To: <7E836D6E-867B-4A35-9B3D-CD1D52E7F2DC@kernel.crashing.org>
References: <20080306135330.6d5462d2@vitb.ru.mvista.com>
	<7E836D6E-867B-4A35-9B3D-CD1D52E7F2DC@kernel.crashing.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008 09:56:58 -0600
Kumar Gala wrote:

> 
> On Mar 6, 2008, at 4:53 AM, Vitaly Bordug wrote:
> 
> > This makes swap routines operate correctly on the ppc_8xx based  
> > machines.
> > Code has been revalidated on mpc885ads (8M sdram) with recent  
> > kernel. Based
> > on patch from Yuri Tikhonov <yur@emcraft.com> to do the same on
> > arch/ ppc
> > instance.
> >
> > Recent kernel's size makes swap feature very important on
> > low-memory platforms,
> > those are actually non-operable without it.
> >
> > Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> > Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> > ---
> >
> > arch/powerpc/kernel/head_8xx.S      |   30
> > ++++++++++++++++++++++++++ +++-
> > include/asm-powerpc/pgtable-ppc32.h |    8 --------
> > 2 files changed, 29 insertions(+), 9 deletions(-)
> 
> do we need similar fixes to arch/ppc ?
> 
there's patch from Yuri that does it for ppc/ - I guess you may just pick it up and place to your tree.

-- 
Sincerely, Vitaly
