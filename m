Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbZFKTSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbZFKTSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZFKTSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:18:24 -0400
Received: from outbound-mail-146.bluehost.com ([67.222.38.36]:41112 "HELO
	outbound-mail-146.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753356AbZFKTSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:18:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=stA4hCvmjm8++DnKlNSGF1L/2uaCHzG6rczFizosDYe6JV3Lr819+xTZPPJn4sdYChx4dBempa3UlJhWEuZfSoC57i+ySwt4IedQIadgigwH4aEZSXGYC1mIrBfhDNv/;
Date: Thu, 11 Jun 2009 12:17:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Martin Mares <mj@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-arch@vger.kernel.org
Subject: Re: RFC: x86: cap iomem_resource to addressable physical memory
Message-ID: <20090611121742.2c0fae8d@jbarnes-g45>
In-Reply-To: <4A2F0D45.2040602@linux.intel.com>
References: <4A2F0D45.2040602@linux.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Jun 2009 18:32:53 -0700
"H. Peter Anvin" <hpa@linux.intel.com> wrote:

> x86 cannot generate full 64-bit addresses; this patch clamps iomem
> addresses to the accessible range.
> 
> I wanted to post it for review before committing it, however; comments
> would be appreciated, especially of the kind "this is done too
> early/too late/in the wrong place/incorrectly".
> 
> 	-hpa

Seems reasonable, since the iomem_resource describes the CPU's view of
MMIO space it should probably reflect what it can actually access.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
