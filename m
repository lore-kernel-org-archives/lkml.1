Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbXFGI07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbXFGI07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXFGI0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:26:51 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:38515 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXFGI0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:26:50 -0400
Date: Thu, 7 Jun 2007 17:25:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whacking out the __get_dma_pages() macro.
Message-ID: <20070607082536.GA15790@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0706070404300.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706070404300.3186@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 04:07:46AM -0400, Robert P. J. Day wrote:
> 
>   the following represents the entire set of calls to the
> __get_dma_pages() macro that i plan on reverting back to the regular
> get_free_pages() macro so __get_dma_pages() can be tossed.  any major
> objections?
> 
> include/asm-sh/floppy.h:	return __get_dma_pages(GFP_KERNEL,get_order(size));
Hmm, I thought I killed that a long time ago.. In any event, we never set
ARCH_MAY_HAVE_PC_FDC, so this header is never used. Feel free to just
kill the header entirely in your conversion patch.
