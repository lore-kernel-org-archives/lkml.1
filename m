Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbXGPWgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbXGPWgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXGPWg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:36:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52426 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754508AbXGPWg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:36:27 -0400
Date: Mon, 16 Jul 2007 15:35:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       geert@linux-m68k.org, zippel@linux-m68k.org, jdike@karaya.com,
       alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: uninline check_signature()
In-Reply-To: <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
 <20070716221257.GA12230@osiris.ibm.com>
 <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Jul 2007, Andrew Morton wrote:
> 
> No, no revert, please.  If the architecture doesn't support readb() then we
> need some reliable way of working that out within Kconfig.

Isn't that CONFIG_HAS_IOMEM?

		Linus
