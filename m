Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbXFSEUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbXFSEUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 00:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXFSET6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 00:19:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37093 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbXFSET5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 00:19:57 -0400
Date: Tue, 19 Jun 2007 05:15:27 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: [patch] use __asm__ and __volatile__ in i386/arm/s390 byteorder.h
Message-ID: <20070619041527.GA7224@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier@gentoo.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, rmk@arm.linux.org.uk
References: <200706171833.29046.vapier@gentoo.org> <20070618183450.GA17112@infradead.org> <20070618190009.GB25340@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618190009.GB25340@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 09:00:09PM +0200, Sam Ravnborg wrote:
> Do you imply that if we see asm or __asm__ in user space headers we ougth
> to warn about it?
> Seems at least sensible to me but if we introduce such a check we should
> kill all offenders first - which Mike's patches seems to trigger for some part.

Yes, we should kill the offenders first.  Some of Mike's patches are moving
nicely in that directions.  The biggest problem from my POV is byteawap.h
that gets dragged in in various places right now and needs to be sorted out.

