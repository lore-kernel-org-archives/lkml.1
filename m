Return-Path: <linux-kernel-owner+w=401wt.eu-S933565AbXGLBSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbXGLBSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758887AbXGLBSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:18:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44612 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535AbXGLBSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:18:12 -0400
Subject: Re: [PATCH 1/1] x86-64: introduce struct pci_sysdata to facilitate
	sharing of ->sysdata
From: Arjan van de Ven <arjan@infradead.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@osdl.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jon Mason <jdmason@gmail.com>
In-Reply-To: <20070711134514.GA4789@rhun.haifa.ibm.com>
References: <20070711134514.GA4789@rhun.haifa.ibm.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 12 Jul 2007 09:17:31 +0800
Message-Id: <1184203051.2693.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 16:45 +0300, Muli Ben-Yehuda wrote:
> Andi, please consider applying for 2.6.23. Applies on top of the
> Calgary update I just sent out ("Calgary: more updates for 2.6.23").
> 
> This patch introduces struct pci_sysdata to x86 and x86-64, and
> converts the existing two users (NUMA, Calgary) to use it.
> 
> This lays the groundwork for having other users of sysdata, such as
> the PCI domains work.
> 
> The Calgary bits are tested, the NUMA bits just look ok.


I very much start to dislike the untyped "sysdata"... I much rather have
separate fields for the different uses (like a IOMMU field) that aren't
going to share ever. Possibly even typed, but for IOMMU that may be
tricky....



