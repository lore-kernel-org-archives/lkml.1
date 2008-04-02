Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbYDBN17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbYDBN17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 09:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYDBN1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 09:27:50 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:42911 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbYDBN1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 09:27:49 -0400
Subject: Re: [PATCH 2/2 v5] Add DIU platform code for MPC8610HPCD
From: York Sun <yorksun@freescale.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       a.p.zijlstra@chello.nl, scottwood@freescale.com,
       avorontsov@ru.mvista.com, timur@freescale.com
In-Reply-To: <20080401140029.be918d87.akpm@linux-foundation.org>
References: <12069806051060-git-send-email-yorksun@freescale.com>
	 <1206980605689-git-send-email-yorksun@freescale.com>
	 <12069806051291-git-send-email-yorksun@freescale.com>
	 <20080401140029.be918d87.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 08:27:43 -0500
Message-Id: <1207142863.20695.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2008 13:27:44.0928 (UTC) FILETIME=[55D0E200:01C894C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 14:00 -0700, Andrew Morton wrote:
> On Mon, 31 Mar 2008 11:23:25 -0500
> York Sun <yorksun@freescale.com> wrote:
> 
> > Add platform code to support Freescale DIU. The platform code includes
> > framebuffer memory allocation, pixel format, monitor port, etc.
> > 
> > Signed-off-by: York Sun <yorksun@freescale.com>
> > Signed-off-by: Timur Tabi <timur@freescale.com>
> > ---
> > This patch addes platform support for Freescale DIU driver, targeting 2.6.26 kernel.
> > 
> >  arch/powerpc/configs/mpc8610_hpcd_defconfig |  198 +++++++++++++++++++++++----
> >  arch/powerpc/platforms/86xx/mpc8610_hpcd.c  |  190 ++++++++++++++++++++++++--
> >  arch/powerpc/sysdev/fsl_soc.c               |   41 ++++++
> >  arch/powerpc/sysdev/fsl_soc.h               |   23 +++
> >  4 files changed, 413 insertions(+), 39 deletions(-)
> 
> The defconfig change gets almost 100% rejects and probably isn't
> appropriate here and isn't very important.  I dropped that part of the
> patch.
> 

It's OK.

York

