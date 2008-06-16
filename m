Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYFPMG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYFPMG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYFPMGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:06:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYFPMGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:06:22 -0400
Subject: Re: [PATCH] ip2: use request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, jaswinder@infradead.org
In-Reply-To: <20080616115950.41bc65aa@lxorguk.ukuu.org.uk>
References: <1213609751.26255.673.camel@pmac.infradead.org>
	 <20080616115950.41bc65aa@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 13:06:19 +0100
Message-Id: <1213617979.26255.713.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 11:59 +0100, Alan Cox wrote:
> On Mon, 16 Jun 2008 10:49:11 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > Converted with help from Jaswinder Singh
> > 
> > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> > ---
> >  drivers/char/Kconfig           |    7 +
> >  drivers/char/ip2/fip_firm.h    | 2149 ----------------------------------------
> >  drivers/char/ip2/ip2base.c     |    5 +-
> >  drivers/char/ip2/ip2main.c     |   45 +-
> >  firmware/Makefile              |    1 +
> >  firmware/WHENCE                |   10 +
> >  firmware/intelliport2.bin.ihex | 2147 +++++++++++++++++++++++++++++++++++++++
> >  7 files changed, 2201 insertions(+), 2163 deletions(-)
> >  delete mode 100644 drivers/char/ip2/fip_firm.h
> >  create mode 100644 firmware/intelliport2.bin.ihex
> 
> Fine by me. I've not checked all the digits are correct but the rest of
> the logic seems clean enough

Yeah, we're trying to be quite careful with the digits, but I'd be a lot
happier when some of this actually gets tested. 

It's good that Jaswinder is now helping -- we can each convert the
firmware and verify that we come up with the same thing. And while I'm
giving a lot of guidance on the _code_ changes, I'm deliberately leaving
him to his own devices for that part, as a kind of 'control' :)

-- 
dwmw2

