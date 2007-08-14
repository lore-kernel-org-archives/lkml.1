Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbXHNLxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbXHNLxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760106AbXHNLxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:53:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37806 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbXHNLxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:53:31 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Woodhouse <dwmw2@infradead.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070814114931.GA13319@aepfle.de>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	 <20070814114931.GA13319@aepfle.de>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 19:53:12 +0800
Message-Id: <1187092392.3707.74.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 13:49 +0200, Olaf Hering wrote:
> On Wed, Apr 04, Paul Mackerras wrote:
> 
> > David Woodhouse writes:
> > 
> > > There are proper device numbers registered for pmac_zilog now. Use them.
> 
> Which numbers?

shinybook /shiny/git/mtd-utils $ ls -l /dev/ttyPZ*
crw-rw---- 1 root uucp 204, 192 2007-08-13 11:48 /dev/ttyPZ0
crw-rw---- 1 root uucp 204, 193 2007-08-13 11:48 /dev/ttyPZ1

-- 
dwmw2

