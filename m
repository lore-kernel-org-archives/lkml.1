Return-Path: <linux-kernel-owner+w=401wt.eu-S1763390AbXHAUCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763390AbXHAUCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbXHAUCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:02:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52320 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXHAUCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:02:36 -0400
Date: Wed, 1 Aug 2007 21:02:33 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andi Kleen <ak@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Deprecate a.out ELF interpreters
Message-ID: <20070801200233.GA30240@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Andi Kleen <ak@novell.com>, linux-kernel@vger.kernel.org
References: <200708011433.09433.ak@novell.com> <Pine.LNX.4.64.0708012029130.26668@fbirervta.pbzchgretzou.qr> <200708012035.52863.ak@novell.com> <Pine.LNX.4.64.0708012125290.26668@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708012125290.26668@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 09:26:10PM +0200, Jan Engelhardt wrote:
> 
> On Aug 1 2007 20:35, Andi Kleen wrote:
> >> On Aug 1 2007 14:33, Andi Kleen wrote:
> >> >Comments?
> >> 
> >> A kconfig entry "(OBSOLETE)"/"(DEPRECATED)" would be nice.
> >> (And if you want to test people, 'depends on EMBEDDED' for CONFIG_BINFMT_AOUT)
> >
> >The point is to have less clutter in binfmt_elf.c (which really
> >could need a rewrite btw or at least a lot of cleanup) not add more in form 
> >of ifdefs.
> 
> 
> ---
>  fs/Kconfig.binfmt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.23/fs/Kconfig.binfmt
> ===================================================================
> --- linux-2.6.23.orig/fs/Kconfig.binfmt
> +++ linux-2.6.23/fs/Kconfig.binfmt
> @@ -56,7 +56,7 @@ config BINFMT_SHARED_FLAT
>  	  Support FLAT shared libraries
>  
>  config BINFMT_AOUT
> -	tristate "Kernel support for a.out and ECOFF binaries"
> +	tristate "Kernel support for a.out and ECOFF binaries (OBSOLETE)"

NAK, binfmt a.out support is something entirely different from what
we're talking about here.
