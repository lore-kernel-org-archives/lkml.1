Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbXIULLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbXIULLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 07:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbXIULLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 07:11:09 -0400
Received: from mail.dsa-ac.de ([62.112.80.99]:44807 "EHLO mail.dsa-ac.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282AbXIULLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 07:11:08 -0400
X-Greylist: delayed 1690 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2007 07:11:08 EDT
Date: Fri, 21 Sep 2007 12:42:55 +0200 (CEST)
From: Guennadi Liakhovetski <gl@dsa-ac.de>
To: Mike Rapoport <mike@compulab.co.il>
Cc: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/03] CM-x270: ITE 8152 PCI bridge support
In-Reply-To: <46F29A0A.4000407@compulab.co.il>
Message-ID: <Pine.LNX.4.63.0709211240570.9343@pcgl.dsa-ac.de>
References: <46F29A0A.4000407@compulab.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, Mike Rapoport wrote:

> This patch provides driver for ITE 8152 PCI bridge.
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> 
>  arch/arm/common/Makefile          |    1 +
>  arch/arm/common/it8152.c          |  387 +++++++++++++++++++++++++++++++++++++

Shouldn't it go to drivers/pci and define a platform driver? it8152 is not 
an ARM specific controller.

Thanks
Guennadi
---------------------------------
Guennadi Liakhovetski, Ph.D.
DSA Daten- und Systemtechnik GmbH
Pascalstr. 28
D-52076 Aachen
Germany
