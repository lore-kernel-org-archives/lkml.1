Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbZDXRMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbZDXRMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZDXRMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:12:47 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:51157 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbZDXRMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:12:47 -0400
Date: Sat, 25 Apr 2009 02:12:46 +0900 (JST)
Message-Id: <20090425.021246.85422107.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: TXx9 Soc DMA Controller driver (v3)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20904240749g79b7b54cufa64149e44b5753a@mail.gmail.com>
References: <1240414831-20429-1-git-send-email-anemo@mba.ocn.ne.jp>
	<e9c3a7c20904240749g79b7b54cufa64149e44b5753a@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 07:49:10 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> > +       /*
> > +        * We use dma_unmap_page() regardless of how the buffers were
> > +        * mapped before they were submitted...
> > +        */
> 
> This will be caught by the new dma-mapping debug infrastructure that
> went in for 2.6.30, but I would not hold up merging this driver for
> this issue.  Once Maciej's fix [1] goes upstream you can fix up your
> driver to use the new "unmap single" flags.

OK, I will follow that when the flag is merged.  Thanks.

---
Atsushi Nemoto
