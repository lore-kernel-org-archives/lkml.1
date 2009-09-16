Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZIPASt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZIPASt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZIPASn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:18:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155AbZIPASn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:18:43 -0400
Date: Tue, 15 Sep 2009 17:18:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dedekind1@gmail.com, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       kmpark@infradead.org, linux-mtd@lists.infradead.org
Subject: Re: 2.6.32 -mm merge plans
Message-Id: <20090915171826.4bd7f1d4.akpm@linux-foundation.org>
In-Reply-To: <20090916000357.GD23923@linux-sh.org>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
	<20090916000357.GD23923@linux-sh.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 09:03:57 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> On Tue, Sep 15, 2009 at 04:15:35PM -0700, Andrew Morton wrote:
> > mtd-make-onenand-genericc-more-generic.patch
> > mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis.patch
> > mtd-nand-add-new-ecc-mode-ecc_hw_oob_first.patch
> > mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips.patch
> > mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update.patch
> > mtd-jffs2-fix-read-buffer-overflow.patch
> > mtd-prevent-a-read-from-eraseregions.patch
> > mtd-prevent-a-read-from-regions.patch
> > mtd-jedec_probe-fix-nec-upd29f064115-detection.patch
> > mtdpart-memory-accessor-interface-for-mtd-layer.patch
> > 
> >   -> dwmw2
> > 
> Regarding mtd-make-onenand-genericc-more-generic.patch, I'm not really
> sure what happened. To recap:
> 
> It was posted to the mtd list here:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2009-August/026805.html
> 
> Kyungmin objected to the driver name change here:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2009-August/026807.html
> 
> I pointed out that the rough rationale for the name change here:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2009-August/026808.html
> 
> and offered to redo the patch keeping the old name if Kyungmin felt the
> rationale wasn't valid, but received no reply. Subsequently, Artem
> mentioned that he had merged it in to his l2-mtd-2.6.git tree here:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2009-August/026866.html
> 
> which subsequently seems to not actually have happened.
> 
> This is a pretty trivial patch, and I don't mind respinning it in
> whatever form folks are content with. I had assumed given the mention
> that it had been merged in to the l2 tree that the rationale was
> sufficient for merging.

I don't think that Artem's tree is in linux-next, so I have no
visibility of what's happening with that patch.

I do think that Artem's tree should be in linux-next.

I guess I'll just hose the patch at dwmw2 and will see what happens.  I
sent it on Aug 6, with no effect.

