Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZAEOCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZAEOCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZAEOCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:02:37 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:49991 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbZAEOCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:02:36 -0500
Date: Mon, 05 Jan 2009 23:02:30 +0900 (JST)
Message-Id: <20090105.230230.132760259.anemo@mba.ocn.ne.jp>
To: haavard.skinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com
Subject: Re: dw_dmac driver questions
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20081229.233932.25909762.anemo@mba.ocn.ne.jp>
References: <20081229.233932.25909762.anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008 23:39:32 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> Hi.  I'm writing a new DMA driver, using dw_dmac driver in kernel
> 2.6.28 as a reference implementation.
> 
> I can see an outline of the dw_dmac driver and framework (well,
> hopefully), but have some questions in details.

One more.

4. This is a comment on head of dwc_handle_error().

	/*
	 * The descriptor currently at the head of the active list is
	 * borked. Since we don't have any way to report errors, we'll
	 * just have to scream loudly and try to carry on.
	 */

But, the bad descriptor can be at any place of the active list, no ?
For example, if the active list contained two descriptor and latter
was broken and tasklet was delayed by some reason, the head of the
list should be good.

---
Atsushi Nemoto
