Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbYGNPWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbYGNPWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbYGNPWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:22:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519AbYGNPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:22:20 -0400
Subject: Re: [PATCH] advansys: use request_firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <20080714151543.GE14894@parisc-linux.org>
References: <1215770322.2733.12.camel@jaswinder.satnam>
	 <20080712162921.GZ14894@parisc-linux.org>
	 <1215882548.19076.57.camel@jaswinder.satnam>
	 <20080714145033.GD14894@parisc-linux.org>
	 <1216047404.27455.31.camel@shinybook.infradead.org>
	 <20080714151543.GE14894@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 08:22:16 -0700
Message-Id: <1216048936.27455.38.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 09:15 -0600, Matthew Wilcox wrote:
> Something I'd like to get rid of in the driver is the decompression
> of the firmware files.  I don't think AdvLoadMicrocode() should have
> a custom decompresser built into it.  Do your future plans include the
> ability to gzip the data and transparently decompress it when the
> driver calls request_firmware()?

It's something we'd thought about, certainly.

-- 
dwmw2

