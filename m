Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbXFACNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbXFACNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 22:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXFACNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 22:13:11 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbXFACNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 22:13:09 -0400
Date: Thu, 31 May 2007 19:12:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1
Message-Id: <20070531191259.afb8f69c.akpm@linux-foundation.org>
In-Reply-To: <465F7DEB.5090700@redhat.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<465F7DEB.5090700@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 23:01:15 -0300 Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/
> >
> > - Merged the convert-cpusets-to-container-infrastructure patches.  These
> >   will probably be dropped and redone.
> >
> >
> >
> >   
> <BIG SNIP>
> >  x86 things
> >
> > +add-select-phylib-to-the-ucc_geth-kconfig-option.patch
> > +m68k-parenthesis-balance.patch
> > +msi-fix-the-ordering-of-msix-irqs.patch
> > +msi-mask-the-msix-vector-before-we-unmap-it.patch
> > +potential-parse-error-in-ifdef.patch
> > +potential-parse-error-in-ifdef-fix.patch
> > +potential-parse-error-in-ifdef-update.patch
> > +pci_ids-update-patch-for-intel-ich9m.patch
> > +x86-fix-oprofile-double-free-was-re-multiple-free.patch
> >   
> http://lkml.org/lkml/2007/5/30/565 fixes the above patch :-)
> 

I don't know what you mean.  The code is already using
for_each_possible_cpu() and
x86-fix-oprofile-double-free-was-re-multiple-free.patch doesn't change
that.

