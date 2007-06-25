Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbXFYP2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbXFYP2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXFYP2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:28:06 -0400
Received: from canuck.infradead.org ([209.217.80.40]:33694 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbXFYP2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:28:05 -0400
Subject: Re: Linux Kernel include files
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org, david@lang.hm
In-Reply-To: <467fdc75.0ficjl92unPDO1uk%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
	 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
	 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
	 <1182483527.10524.31.camel@shinybook.infradead.org>
	 <467fdc75.0ficjl92unPDO1uk%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 16:27:57 +0100
Message-Id: <1182785277.12109.121.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 17:17 +0200, Joerg Schilling wrote:
> David Woodhouse <dwmw2@infradead.org> wrote:
> > On Fri, 2007-06-22 at 01:38 +0200, Joerg Schilling wrote:
> A kernel include file that defines an interface to a user space program
> should be self containing (that means that all includes for all non-standard
> types should be done inside these include files). Whether or not C-99 
> types are used or not is less important than to use type definitions written 
> in clean C so compilers other than gcc may use them.

Yes. In general we try to achieve this. Most header files should include
<asm/types.h>, which tends to define the types we use in terms which
should work in any compiler.

> >  Can you be more specific about why this is a problem? Don't
> > we mostly define those crappy types using arch-specific knowledge, as
> > 'int', 'long', etc?
> 
> I recommend you to install Sun Studio and to try to compile star or cdrtools
> using Sun Studio by calling "make CCOM_suncc".
>
> ftp://ftp.berlios.de/pub/star/alpha/
> ftp://ftp.berlios.de/pub/cdrecord/alpha/
> 
> You may need to hand edit the file incs/<arch-dir>/{xconfig.h!rules.conf}
> 
> in order to enable the auto-disabled features.
> 
> In any case, self reading the error messages from Sun Studio helps more than
> trying to discuss it.

I have no interest in doing this for myself, and I suspect that if I
tried it I'd find that Sun Studio doesn't exist for Linux/PowerPC
anyway. Please just show the error messages.

-- 
dwmw2

