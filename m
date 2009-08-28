Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZH1Fqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZH1Fqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 01:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZH1Fq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 01:46:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:45441 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbZH1Fq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 01:46:26 -0400
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Message-Id: <5BA465E6-25AB-4402-85EF-40CDDD2E471B@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20090818220416.GC25090@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 3/8] powerpc/cpm: Move CPMFCR_* defines into cpm.h
Date: Fri, 28 Aug 2009 00:45:51 -0500
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru> <20090818220416.GC25090@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 18, 2009, at 5:04 PM, Anton Vorontsov wrote:

> The bits are generic to CPM devices, so let's move them to the
> common header file, so drivers won't need to privately reintroduce
> another bunch of the same bits (as we can't include cpm2.h header
> together with cpm1.h).
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> arch/powerpc/include/asm/cpm.h  |   16 ++++++++++++++++
> arch/powerpc/include/asm/cpm2.h |    8 --------
> 2 files changed, 16 insertions(+), 8 deletions(-)


applied to next

- k
