Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbZIPJhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbZIPJhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZIPJhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:37:05 -0400
Received: from 175.210.DSNET ([203.110.175.210]:4611 "EHLO mail.atheros.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752111AbZIPJhE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:37:04 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 05:37:04 EDT
From: Jie Yang <Jie.Yang@Atheros.com>
To: Daniel Walker <dwalker@fifo99.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
       "miles.lane@gmail.com" <miles.lane@gmail.com>,
       "chris.snook@gmail.com" <chris.snook@gmail.com>,
       "jcliburn@gmail.com" <jcliburn@gmail.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 16 Sep 2009 17:31:40 +0800
Subject: RE: [Patch net-next]atl1e:fix 2.6.31-git4 -- ATL1E 0000:03:00.0:
 DMA-API: device driver frees DMA
Thread-Topic: [Patch net-next]atl1e:fix 2.6.31-git4 -- ATL1E 0000:03:00.0:
 DMA-API: device driver frees DMA
Thread-Index: Aco2rX2tRNxWqDBvR2uSP8/glOl+BwAAtfiA
Message-ID: <72981EBCFD196144B7C6999B9FC34A9A493DE96CD7@SHEXMB-01.global.atheros.com>
References: <12530821133392-git-send-email-jie.yang@atheros.com>
 <1253092251.11643.569.camel@desktop>
In-Reply-To: <1253092251.11643.569.camel@desktop>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 16, 2009 5:11 PM
Daniel Walker <dwalker@fifo99.com> wrote:

> On Wed, 2009-09-16 at 14:21 +0800, jie.yang@atheros.com wrote:
> > -           pci_unmap_page(pdev, tx_buffer->dma,
> > +           if (tx_buffer->flags & ATL1E_TX_PCIMAP_SINGLE)
> > +               pci_unmap_single(pdev, tx_buffer->dma,
> > +                   tx_buffer->length, PCI_DMA_TODEVICE);
> > +           else if (tx_buffer->flags & ATL1E_TX_PCIMAP_PAGE)
> > +               pci_unmap_page(pdev, tx_buffer->dma,
>
> Could you run this through checkpatch, and fix any errors if
> find? It looks like you uses spaces for tabs in the code
> above, maybe in the other block too..
>
> Daniel
>
>

ou, my mistake, just resend.

Best  wishes
jie
