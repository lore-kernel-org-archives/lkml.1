Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbYDAVDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbYDAVDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760450AbYDAVBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:01:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760833AbYDAVBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:01:34 -0400
Date: Tue, 1 Apr 2008 14:00:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: York Sun <yorksun@freescale.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       a.p.zijlstra@chello.nl, scottwood@freescale.com,
       avorontsov@ru.mvista.com, yorksun@freescale.com, timur@freescale.com
Subject: Re: [PATCH 2/2 v5] Add DIU platform code for MPC8610HPCD
Message-Id: <20080401140029.be918d87.akpm@linux-foundation.org>
In-Reply-To: <12069806051291-git-send-email-yorksun@freescale.com>
References: <12069806051060-git-send-email-yorksun@freescale.com>
	<1206980605689-git-send-email-yorksun@freescale.com>
	<12069806051291-git-send-email-yorksun@freescale.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008 11:23:25 -0500
York Sun <yorksun@freescale.com> wrote:

> Add platform code to support Freescale DIU. The platform code includes
> framebuffer memory allocation, pixel format, monitor port, etc.
> 
> Signed-off-by: York Sun <yorksun@freescale.com>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> This patch addes platform support for Freescale DIU driver, targeting 2.6.26 kernel.
> 
>  arch/powerpc/configs/mpc8610_hpcd_defconfig |  198 +++++++++++++++++++++++----
>  arch/powerpc/platforms/86xx/mpc8610_hpcd.c  |  190 ++++++++++++++++++++++++--
>  arch/powerpc/sysdev/fsl_soc.c               |   41 ++++++
>  arch/powerpc/sysdev/fsl_soc.h               |   23 +++
>  4 files changed, 413 insertions(+), 39 deletions(-)

The defconfig change gets almost 100% rejects and probably isn't
appropriate here and isn't very important.  I dropped that part of the
patch.

