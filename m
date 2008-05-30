Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYE3KiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYE3KiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYE3KiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:38:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYE3KiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:38:11 -0400
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
From: David Woodhouse <dwmw2@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       matthew@wil.cx, arjan@linux.intel.com, greg@kroah.com,
       James.Bottomley@hansenpartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5habi8ce51.wl%tiwai@suse.de>
References: <483F1232.4010003@linux.intel.com>
	 <20080529204736.GZ22636@parisc-linux.org>
	 <86802c440805291355p5697c775k5f0beb8163688058@mail.gmail.com>
	 <20080529.143157.02330907.davem@davemloft.net>
	 <86802c440805291457r71340133pc413b7f1e78e5df3@mail.gmail.com>
	 <s5habi8ce51.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Fri, 30 May 2008 13:37:58 +0300
Message-Id: <1212143878.29244.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-30 at 11:52 +0200, Takashi Iwai wrote:
> OTOH, it doesn't give you any error at build time even if you forget
> to put a firmware image beforehand.  The kernel continues to look for
> a non-existing external firmware file.  In the old code, this can't
> happen.

Perhaps we should make depmod also check all MODULE_FIRMWARE() and
complain about missing firmware which might be used? We could make it
(or something else) check for firmwares required by drivers built in to
the kernel, too.

-- 
dwmw2

