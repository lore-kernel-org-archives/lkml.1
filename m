Return-Path: <linux-kernel-owner+w=401wt.eu-S1767304AbXECB1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767304AbXECB1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 21:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767302AbXECB1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 21:27:12 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1362 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767304AbXECB1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 21:27:11 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/33] m68k patches for 2.6.22
Date: Thu, 3 May 2007 03:27:01 +0200
User-Agent: KMail/1.9.5
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20070501203234.252205858@mail.of.borg> <20070501204946.GB21080@infradead.org>
In-Reply-To: <20070501204946.GB21080@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705030327.02637.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 01 May 2007 22:49, Christoph Hellwig wrote:

> Btw, is there any chance you could update m68k to use the generic
> irq code?  The only architectures that don't have a conversion
> in progress are m68k, m68knommu and arm26

I haven't looked seriously into it since it was pretty much rewritten.
What I need is very close control over the lowlevel handling to minimize the 
number of indirect calls and to get the interrupt delivered as fast as 
possible. (E.g. we even patch the assembler entry, so the basic flow control 
is pretty much fixed after boot.)
I don't mind the if the general management is a bit more complex, but how do I 
get rid of all the useless code?
At a bit closer look e.g. irq_desc would need a serious diet, it can produce a 
pretty large table...

bye, Roman
