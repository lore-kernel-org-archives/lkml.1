Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbZGAG3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbZGAG3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZGAG3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:29:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57224 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZGAG3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:29:45 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "Gadiyar, Anand" <gadiyar@ti.com>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>
CC: "pierre@ossman.eu" <pierre@ossman.eu>, Tony Lindgren <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 1 Jul 2009 11:59:28 +0530
Subject: RE: [PATCH] OMAP: HSMMC: Do not enable buffer ready interrupt if
 using DMA
Thread-Topic: [PATCH] OMAP: HSMMC: Do not enable buffer ready interrupt if
 using DMA
Thread-Index: AcnNZ/m5/8MKE+GxRGWQOER2Yy6DygAuIxugAzEkNYAHy/GREA==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0305B783F3@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB03057422B4@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009, Gadiyar, Anand wrote:
> On Wed, May 06, 2009, Gadiyar, Anand wrote:
> > On Tue, May 5, 2009, Jarkko Lavinen wrote: 
> > > On Tue, Apr 21, 2009 at 09:39:22AM +0200, ext Gadiyar, Anand wrote:
> > > > From: Anand Gadiyar <gadiyar@ti.com>
> > > > 
> > > > OMAP: HSMMC: Do not enable buffer ready interrupt if using DMA
> > > > 
> > > > This considerably reduces the number of interrupts during a transfer
> > > > and ought to result in some power saving.
> > > 
> > > I tried the patch with reading from the raw mmc block device to
> > > /dev/null with dd (with bs 32k and 1M).  I cannot see any
> > > difference in interrupt count from /proc/interrupts or in read
> > > speed. At least the patch works. Cpu was 34340es3.
> > > 
> > > I also trid without the patch just disabling the Buffer
> > > Read/write Ready bits from INT_EN_MASK which is then written to
> > > both MMCHS_IE and MMCHS_ISE.  Still no change in read speed nor
> > > mmc irq count.
> > > 
> > > Cheers
> > > Jarkko Lavinen
> > 
> > I discovered this while doing MMC writes. I did not check if there
> > was any difference during a read. I notice you have only tested with
> > MMC reads.
> > 
> > Here's what I get with and without the patch.
> > 
> > - Anand
> 
> 
> Any comments on this? Is it safe to merge?
> 
> Thanks,
> Anand

<snip>


Ping?

Patchwork link is:
http://patchwork.kernel.org/patch/19133/

