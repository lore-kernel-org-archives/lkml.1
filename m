Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237Ab0ATQzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0ATQzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748Ab0ATQzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:55:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47638 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab0ATQzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:55:01 -0500
Date: Wed, 20 Jan 2010 16:54:44 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [CFT] MM: Pass a PTE pointer to update_mmu_cache() rather than
	the PTE itself
Message-ID: <20100120165443.GB3284@flint.arm.linux.org.uk>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100120135202.GA20937@flint.arm.linux.org.uk> <10f740e81001200845o7a31bcb6yea475f3aabcb5476@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10f740e81001200845o7a31bcb6yea475f3aabcb5476@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 05:45:34PM +0100, Geert Uytterhoeven wrote:
> > diff --git a/Documentation/cachetlb.txt b/Documentation/cachetlb.txt
> > index da42ab4..74a8b6f 100644
> > --- a/Documentation/cachetlb.txt
> > +++ b/Documentation/cachetlb.txt
> > @@ -88,12 +88,12 @@ changes occur:
> >        This is used primarily during fault processing.
> >
> >  5) void update_mmu_cache(struct vm_area_struct *vma,
> > -                        unsigned long address, pte_t pte)
> > +                        unsigned long address, pte_t *ptep)
> >
> >        At the end of every page fault, this routine is invoked to
> >        tell the architecture specific code that a translation
> > -       described by "pte" now exists at virtual address "address"
> > -       for address space "vma->vm_mm", in the software page tables.
> > +       now exists at virtual address "address" for address space
> > +       "vma->vm_mm", in the software page tables.
> >
> >        A port may use this information in any way it so chooses.
> >        For example, it could use this event to pre-load TLB
> 
> Now the documentation no longer mentions what the 3rd parameter is used for?

I'm open to suggestions for a suitable description for it.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
