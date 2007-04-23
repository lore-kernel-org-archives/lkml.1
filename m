Return-Path: <linux-kernel-owner+w=401wt.eu-S1161497AbXDWLxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161497AbXDWLxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161507AbXDWLxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:53:21 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58444 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161497AbXDWLxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:53:20 -0400
X-Originating-Ip: 74.109.98.66
Date: Mon, 23 Apr 2007 07:52:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Rene Herman <rene.herman@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@stusta.de>, Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
In-Reply-To: <1177327476.17026.75.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>
References: <46138B4C.2050409@gmail.com>  <20070404123311.GA18552@infradead.org>
 <1175698135.5815.447.camel@violet>  <20070404150231.GE27660@stusta.de>
 <4613C963.6070409@gmail.com>  <20070404170016.453d26f1@the-village.bc.nu>
 <4613D492.2070404@gmail.com>  <462C7D74.60003@gmail.com>
 <1177327476.17026.75.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Rusty Russell wrote:

> On Mon, 2007-04-23 at 11:33 +0200, Rene Herman wrote:
> > On 04/04/2007 06:38 PM, Rene Herman wrote:
> >
> > Rusty?
>
> Valid points have been made on both sides.  I suggest:
>
> #define MODULE_MAINTAINER(_maintainer) \
> 	MODULE_AUTHOR("(Maintained by) "_maintainer)

why bring MODULE_AUTHOR into it?  just define it in terms of
MODULE_INFO:

#define MODULE_MAINTAINER(_m) MODULE_INFO(_m, "(Maintained by)"  \
	maintainer)

technically, the maintainer is not the same as the author so why
confuse the issue with an extra unnecessary macro expansion?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
