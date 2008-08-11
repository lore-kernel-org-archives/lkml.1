Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbYHKO41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbYHKO41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHKO4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:56:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYHKO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:56:18 -0400
Subject: Re: [RFC 1/3] add support for exporting symbols from .S files
From: David Woodhouse <dwmw2@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, linuxppc-dev@ozlabs.org
In-Reply-To: <200808111618.08206.arnd@arndb.de>
References: <200808111606.44103.arnd@arndb.de>
	 <200808111618.08206.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 15:56:11 +0100
Message-Id: <1218466571.2977.6.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 16:18 +0200, Arnd Bergmann wrote:
> This makes it possible to export symbols from assembly files, instead
> of having to export them through an extra ksyms.c file.
> 
> I found this nicer to implement using a gas macro than a cpp macro.

Yeah, gas macros can be much nicer. This looks good to me; I don't see
and reason why it can't be used across all architectures, off-hand.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



