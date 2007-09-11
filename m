Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbXIKOUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbXIKOUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXIKOUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:20:35 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:45215 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbXIKOUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:20:34 -0400
Date: Tue, 11 Sep 2007 09:20:14 -0500
From: Scott Wood <scottwood@freescale.com>
To: Zhang Wei-r63237 <Wei.Zhang@freescale.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>, paulus@samba.org,
       linuxppc-dev@ozlabs.org, dan.j.williams@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Message-ID: <20070911142014.GG1932@ld0162-tx32.am.freescale.net>
References: <11891624582950-git-send-email-wei.zhang@freescale.com> <BAE9DCEF64577A439B3A37F36F9B691C02FF08A1@orsmsx418.amr.corp.intel.com> <46B96294322F7D458F9648B60E15112C85D61E@zch01exm26.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B96294322F7D458F9648B60E15112C85D61E@zch01exm26.fsl.freescale.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 06:10:53PM +0800, Zhang Wei-r63237 wrote:
> > >+
> > >+	fsl_dma_memcpy_issue_pending(chan);
> > >+	while (fsl_dma_is_complete(chan, cookie, NULL, NULL)
> > >+			!= DMA_SUCCESS);
> > 
> > Again, is it possible to hang your thread here?
> > 
> > [...]
> 
> I'll add msleep here.

I think what was being sought was a timout, causing the test to return
failure.

-Scott
