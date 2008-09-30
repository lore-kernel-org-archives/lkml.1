Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbYJAFa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbYJAFa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 01:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYJAFaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 01:30:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:53266 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYJAFaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 01:30:17 -0400
Date: Tue, 30 Sep 2008 15:30:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20080930153001.1107c0de@infradead.org>
In-Reply-To: <20081001052450.GB7348@colo.lackof.org>
References: <20080926163641.288bf868@infradead.org>
	<20080926163718.32f0867e@infradead.org>
	<20080929072643.GA28871@colo.lackof.org>
	<20080929064220.374c68a4@infradead.org>
	<20080929171049.GA14409@colo.lackof.org>
	<20080929102325.0ca5c0c9@infradead.org>
	<20081001052450.GB7348@colo.lackof.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 23:24:50 -0600
Grant Grundler <grundler@parisc-linux.org> wrote:

> 
> > And pci_iomap() takes more parameters than most driver writers want
> > or need. Most of the time it's "I want the whole bar"; even if my
> > patch wraps around that, making the API simpler is still worth it
> > imo
> 
> You are right about that.
> Would calling the API "pci_iomap_bar()" to keep the naming consistent
> help make it more acceptable?

I'm fine with pci_iomap_bar()... it meets my goals
Would be nice if I'd be allowed to make it only work on MEM bars not IO
bars (so that drivers don't accidentally end up calling this on an IO
bar and then using readl() etc)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
