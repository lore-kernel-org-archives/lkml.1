Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbXDEObJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbXDEObJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXDEObI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:31:08 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:64531 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbXDEObG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:31:06 -0400
Date: Thu, 05 Apr 2007 23:31:01 +0900 (JST)
Message-Id: <20070405.233101.106261123.anemo@mba.ocn.ne.jp>
To: dwmw2@infradead.org
Cc: paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       device@lanana.org
Subject: Re: [PATCH v3] Stop pmac_zilog from abusing 8250's device numbers;
 optionally.
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1175696383.2774.24.camel@shinybook.infradead.org>
References: <1175666635.2932.17.camel@shinybook.infradead.org>
	<17939.17962.248566.886449@cargo.ozlabs.ibm.com>
	<1175696383.2774.24.camel@shinybook.infradead.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 10:19:43 -0400, David Woodhouse <dwmw2@infradead.org> wrote:
> +#ifdef CONFIG_SERIAL_PMACZILOG_TTYS
> +#define PMACZILOG_MAJOR		TTY_MAJOR
> +#define PMACZILOG_MINOR		64
> +#define PMACZILOG_NAME		"ttyS"
> +#else
> +#define PMACZILOG_MAJOR		204
> +#define PMACZILOG_MINOR		192
> +#define PMACZILOG_NAME		"ttyPZ"
> +#endif

Is major 204 minor 192 already allocated?

Few weeks ago, I sent a patch to allocate 192...199 for other serial
driver (Subject: [PATCH 2.6.21-rc3] serial: Allocate minor device
numbers for serial_txx9 driver):

http://lkml.org/lkml/2007/3/13/246

And it is already in -mm tree since 2.6.21-rc4-mm1.  I just CC-ed the
patch to device@lanana.org, but I really do not know how "master"
devices.txt updated finally.  If I should take some further action to
lanana.org or someone, please let me know.  Thank you.

---
Atsushi Nemoto
