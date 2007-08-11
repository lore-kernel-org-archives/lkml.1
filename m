Return-Path: <linux-kernel-owner+w=401wt.eu-S932345AbXHKDtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbXHKDtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 23:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXHKDti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 23:49:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50123 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbXHKDth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 23:49:37 -0400
Date: Sat, 11 Aug 2007 04:49:35 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] aic94xx: new driver
Message-ID: <20070811034935.GC22216@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	James Bottomley <James.Bottomley@SteelEye.com>
References: <200609240400.k8O403OJ024220@hera.kernel.org> <1186758562.7615.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186758562.7615.6.camel@shinybook.infradead.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 11:09:22PM +0800, David Woodhouse wrote:
> The files in /usr/include/scsi are actually shipped by glibc, and most
> distributions use glibc's version instead of the one from the kernel --
> so this additional userspace interface is automatically incompatible
> with most people's installations.

Stop here right now.  You just noticed the real bug, and that's exporting
scsi.h at all.  I think Olaf sent a patch to fix this already.

