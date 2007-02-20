Return-Path: <linux-kernel-owner+w=401wt.eu-S964979AbXBTPRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979AbXBTPRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965021AbXBTPRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:17:32 -0500
Received: from mx1.suse.de ([195.135.220.2]:34257 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964979AbXBTPRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:17:31 -0500
Date: Tue, 20 Feb 2007 16:17:30 +0100
From: Nick Piggin <npiggin@suse.de>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] perfmon ia64: fix file/vma lifetime
Message-ID: <20070220151730.GC5044@wotan.suse.de>
References: <20070220141856.GB31343@wotan.suse.de> <20070220143454.GD30911@frankl.hpl.hp.com> <20070220150844.GB5044@wotan.suse.de> <20070220151408.GF30911@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220151408.GF30911@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 07:14:08AM -0800, Stephane Eranian wrote:
> Nick,
> 
> > Not that I've looked at the code, but can I be hopeful that v2.3
> > using the traditional mmap file operation to set up the vma and map
> > in pages, rather than the way that v2.0 works?
> > 
> 
> It does. You need an explicit mmap()  call.

Good to hear, thanks Stephane.
