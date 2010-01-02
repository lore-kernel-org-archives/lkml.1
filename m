Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038Ab0ABXJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0ABXJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 18:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446Ab0ABXJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 18:09:08 -0500
Received: from mail2.shareable.org ([80.68.89.115]:57328 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0ABXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 18:09:07 -0500
Date: Sat, 2 Jan 2010 23:09:07 +0000
From: Jamie Lokier <jamie@shareable.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [uClinux-dev] [PATCH] Valid relocation symbol for FLAT format on ARM, v2
Message-ID: <20100102230906.GB32298@shareable.org>
References: <20100101012645.GB16887@Pogoplug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100101012645.GB16887@Pogoplug>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jun Sun wrote:
> +/* [jsun] new gcc 4.x generates ANCHOR symbols in order to reduce the size
> + * of GOT table for PIC code. It is possible the ANCHOR is placed beyond
> + * the end of data/bss segment up to 4K bytes(12 bits), because ARM allows
> + * negative 12-bit offset. Thus we allow 0x1000 extra in reloc address range.
> + */

Can you provide a small test program and *exact* GCC version and
Binutils version which triggers this?  People have reported using GCC
4.x on ARM uClinux for some time, and I haven't seen complaints
about this problem before.

Thanks,
-- Jamie
