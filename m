Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbXHKGmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbXHKGmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 02:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXHKGly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 02:41:54 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58512 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbXHKGlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 02:41:52 -0400
Subject: Re: [SCSI] aic94xx: new driver
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>
In-Reply-To: <20070811034935.GC22216@infradead.org>
References: <200609240400.k8O403OJ024220@hera.kernel.org>
	 <1186758562.7615.6.camel@shinybook.infradead.org>
	 <20070811034935.GC22216@infradead.org>
Content-Type: text/plain
Date: Sat, 11 Aug 2007 14:41:39 +0800
Message-Id: <1186814499.3169.2.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-11 at 04:49 +0100, Christoph Hellwig wrote:
> On Fri, Aug 10, 2007 at 11:09:22PM +0800, David Woodhouse wrote:
> > The files in /usr/include/scsi are actually shipped by glibc, and most
> > distributions use glibc's version instead of the one from the kernel --
> > so this additional userspace interface is automatically incompatible
> > with most people's installations.
> 
> Stop here right now.  You just noticed the real bug, and that's exporting
> scsi.h at all.  I think Olaf sent a patch to fix this already. 

That's a good enough answer for me, certainly.

-- 
dwmw2

