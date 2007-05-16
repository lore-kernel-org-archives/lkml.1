Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbXEPHNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbXEPHNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbXEPHNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:13:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44239 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXEPHNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:13:02 -0400
Date: Wed, 16 May 2007 08:13:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       netdev@vger.kernel.org, Michael Jones <mlj28@cam.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Message-ID: <20070516071300.GB14222@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk, netdev@vger.kernel.org,
	Michael Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>
References: <464034CF.20700@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464034CF.20700@wpkg.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 10:29:03AM +0200, Tomasz Chmielewski wrote:
> Michael Jones wrote:
> 
> >>+#ifndef __ARMEB__
> >>+#warning Little endian mode not supported
> >>+#endif
> >
> >Personally I'm less fussed about WAN / LE support. Anyone with any  
> >sense will run ixp4xx boards doing such a specialised network  
> >operation as BE. Also, NSLU2-Linux can't test this functionality with  
> >our LE setup as we don't have this hardware on-board. You may just  
> >want to declare a depends on ARMEB in Kconfig (with or without OR  
> >(ARM || BROKEN) ) and have done with it - it's up to you.
> 
> Christian Hohnstaedt's work did support LE though.
> 
> Not all ixp4xx boards are by definition "doing such a specialised 
> network operation".
> 
> 
> Krzysztof, why is LE not supported?
> 
> Do you need access to ixp4xx that starts in LE mode?

Not even trying to support LE is a clear merge blocker.  Maybe Krzysztof
can't actually test it himself, which is fine - but not even pretending
to be endian clean is not what proper Linux drivers do.
