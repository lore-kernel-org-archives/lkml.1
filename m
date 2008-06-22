Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbYFVLuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbYFVLuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 07:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYFVLuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 07:50:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYFVLuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 07:50:12 -0400
Subject: Re: architectures with ARCH_SUPPORTS_AOUT but no binfmt_aout
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, dhowells@redhat.com, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-arch@vger.kernel.org, gerg@uclinux.org
In-Reply-To: <20080622094907.GF27069@cs181133002.pp.htv.fi>
References: <1213565555.26255.522.camel@pmac.infradead.org>
	 <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
	 <1213617663.26255.708.camel@pmac.infradead.org>
	 <20080616121727.GB10854@cs181133002.pp.htv.fi>
	 <1213619214.26255.721.camel@pmac.infradead.org>
	 <20080617084235.GA20169@cs181133002.pp.htv.fi>
	 <1213696004.26255.960.camel@pmac.infradead.org>
	 <20080617101112.GE20169@cs181133002.pp.htv.fi>
	 <1213702113.26255.996.camel@pmac.infradead.org>
	 <20080622094907.GF27069@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Sun, 22 Jun 2008 12:40:50 +0100
Message-Id: <1214134850.2409.2.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-22 at 12:49 +0300, Adrian Bunk wrote:
> 
> What about m68knommu?
> 
> I don't know whether it was intentionally available there, but the 
> removal in your patch does not seem to be intentional.

Hm, true. Well spotted. I think it's probably correct though -- I don't
think m68knommu can really support a.out binaries, can it?

-- 
dwmw2

