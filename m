Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbZBHAlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbZBHAlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 19:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZBHAlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 19:41:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:47306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZBHAlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 19:41:08 -0500
Date: Sat, 7 Feb 2009 16:40:57 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: wixor <wixorpeek@gmail.com>, JosephChan@via.com.tw,
       linux-kernel@vger.kernel.org
Subject: Re: viafb triggers BUG at mm/vmalloc.c:294 [kernel 2.6.28.3]
Message-ID: <20090207164057.777f482f@infradead.org>
In-Reply-To: <20090207205606.GA3490@x200.localdomain>
References: <c43b2e150902071144j4f01e754y83205ad8d734fd95@mail.gmail.com>
	<20090207200652.GA3255@x200.localdomain>
	<c43b2e150902071217id7bfdbaq66dbbd7d5e370c23@mail.gmail.com>
	<20090207205606.GA3490@x200.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 23:56:07 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Two more things.
> 
> 1. In via_pci_probe(), there are two ioremap() calls. Insert printks
>    before them to determine which of ioremaps is failing (I bet it's
> the first one, still...)

hmm that makes me wonder

the scripts/markup_oops.pl script currently only shows where in the C
code the EIP/top entry is... but that's just a choice, it could work on
arbitrary stack depth. That would be an easy add on.. easy to hack for
me if people think it's worth it...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
 
