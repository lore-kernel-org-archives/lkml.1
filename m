Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYIYSke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYIYSke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYIYSkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:40:25 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:46911 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYIYSkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:40:25 -0400
Date: Thu, 25 Sep 2008 13:40:20 -0500
From: Scott Wood <scottwood@freescale.com>
To: Timur Tabi <timur@freescale.com>
Cc: Li Yang <leoli@freescale.com>, linuxppc-dev@ozlabs.org,
       dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fsl-dma: allow Freescale Elo DMA driver to be compiled as a module
Message-ID: <20080925184020.GA5230@ld0162-tx32.am.freescale.net>
References: <1222293567-17694-1-git-send-email-timur@freescale.com> <2a27d3730809242354u4cc24b96yda3973bfc3ddac92@mail.gmail.com> <48DB9816.4020603@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DB9816.4020603@freescale.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 08:54:30AM -0500, Timur Tabi wrote:
> Li Yang wrote:
> 
> >> -subsys_initcall(of_fsl_dma_chan_init);
> >>  subsys_initcall(of_fsl_dma_init);
> > 
> > Not a critical problem.  But module_init() are preferred for modules.
> 
> This was intentional.  When compiled as a module, subsys_initcall becomes
> module_init().  When compiled in-kernel, this code is initialized before most
> drivers, so it's ready when the drivers are loaded.

If there's a dependency there, how will it work when this is built as a
module?

-Scott
