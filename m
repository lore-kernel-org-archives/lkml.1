Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYFVXxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYFVXxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 19:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbYFVXxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 19:53:38 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:53423 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754041AbYFVXxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 19:53:36 -0400
Date: Mon, 23 Jun 2008 09:53:32 +1000
From: David McCullough <David_Mccullough@securecomputing.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, Peter Korsgaard <jacmet@sunsite.dk>,
       linux-kernel@vger.kernel.org, sam@ravnborg.org, dhowells@redhat.com,
       andi@firstfloor.org, "Kirill A. Shutemov" <k.shutemov@gmail.com>,
       ysato@users.sourceforge.jp, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-arch@vger.kernel.org, gerg@uclinux.org
Subject: Re: architectures with ARCH_SUPPORTS_AOUT but no binfmt_aout
Message-ID: <20080622235332.GA16055@securecomputing.com>
References: <1213604973-7073-1-git-send-email-jacmet@sunsite.dk> <1213617663.26255.708.camel@pmac.infradead.org> <20080616121727.GB10854@cs181133002.pp.htv.fi> <1213619214.26255.721.camel@pmac.infradead.org> <20080617084235.GA20169@cs181133002.pp.htv.fi> <1213696004.26255.960.camel@pmac.infradead.org> <20080617101112.GE20169@cs181133002.pp.htv.fi> <1213702113.26255.996.camel@pmac.infradead.org> <20080622094907.GF27069@cs181133002.pp.htv.fi> <1214134850.2409.2.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214134850.2409.2.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin David Woodhouse lays it down ...
> On Sun, 2008-06-22 at 12:49 +0300, Adrian Bunk wrote:
> > 
> > What about m68knommu?
> > 
> > I don't know whether it was intentionally available there, but the 
> > removal in your patch does not seem to be intentional.
> 
> Hm, true. Well spotted. I think it's probably correct though -- I don't
> think m68knommu can really support a.out binaries, can it?

No it can't.

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org   http://www.snapgear.com
