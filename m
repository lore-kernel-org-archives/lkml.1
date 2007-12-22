Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbXLVUQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbXLVUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbXLVUQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:16:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45243 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXLVUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:16:19 -0500
Date: Sat, 22 Dec 2007 12:15:03 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Martin Mares <mj@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
 driver opt-in issue
Message-ID: <20071222121503.3502382a@laptopd505.fenrus.org>
In-Reply-To: <mj+md-20071222.192526.25019.nikam@ucw.cz>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
	<476D1D16.5090703@garzik.org>
	<20071222064719.73fdd9a4@laptopd505.fenrus.org>
	<alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
	<mj+md-20071222.192526.25019.nikam@ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 20:30:58 +0100
Martin Mares <mj@ucw.cz> wrote:

> Hello!
> 
> > Just make it so. The name is fine, the concept is unavoidable. The
> > people who complain are whiners that haven't ever had to deal with
> > the fact that there are broken machines around. 
> 
> I complain as well as the maintainer of the pciutils. Breaking all
> userspace accesses to extended configuration space just because there
> is a couple of chipsets

it's not "just a couple of chipsets", it's actually
* a whole lot of bioses
* at least one whole CPU generation
* ..
* ..

Do you really want to code all of that into your userspace access code as well?
