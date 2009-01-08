Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbZAHV53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbZAHV53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 16:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZAHV5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 16:57:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbZAHV5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 16:57:19 -0500
Date: Thu, 8 Jan 2009 13:56:25 -0800
From: Dirk Hohndel <hohndel@infradead.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: git-latest: kernel oops in IOMMU setup
Message-ID: <20090108135625.7e8dc1b4@infradead.org>
In-Reply-To: <20090108214116.GB20506@colo.lackof.org>
References: <20090108120538.0176d348@infradead.org>
	<20090108214116.GB20506@colo.lackof.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 14:41:16 -0700
Grant Grundler <grundler@parisc-linux.org> wrote:

> On Thu, Jan 08, 2009 at 12:05:38PM -0800, Dirk Hohndel wrote:
> > 
> > latest git from Linus. On a Thinkpad x200s with VT-d enabled (if I
> > disable VT-d, this of course goes away). 
> > 
> > The oops happens very early during boot in device_to_iommu (called
> > from domain_context_mapping_one).

Look here, that's where it's called from.
Do you want me to note down the complete backtrace?


> If you can, a back trace. Basically just need to know which caller
> is tripping over this. But there can't be that many callers and they
> are all in this file:
> ...
> so it should be possible to figure out which one is called
> before the dev is setup. It's unlikely to be anything with
> "remove" in the name. :)

correct - it's context_mapping_one

-- 
Dirk Hohndel
Intel Open Source Technology Center
