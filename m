Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZEBVqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZEBVqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 17:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZEBVqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 17:46:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60173 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbZEBVqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 17:46:01 -0400
Subject: Re: [RFC][PATCH 13/35] parisc: create ptemap.h
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090502142939.GD28342@bombadil.infradead.org>
References: <20090501144201.D31EF417@kernel>
	 <20090501144221.4C7F3D79@kernel>
	 <20090502142939.GD28342@bombadil.infradead.org>
Content-Type: text/plain
Date: Sat, 02 May 2009 14:45:59 -0700
Message-Id: <1241300759.9131.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-02 at 10:29 -0400, Kyle McMartin wrote:
> On Fri, May 01, 2009 at 07:42:21AM -0700, Dave Hansen wrote:
> > +#ifndef _PARISC_ASM_PTEMAP_H
> > +#define _PARISC_ASM_PTEMAP_H
> > +
> > +#define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
> > +#define pte_offset_map_nested(pmd, address) pte_offset_kernel(pmd, address)
> > +#define pte_unmap(pte) do { } while (0)
> > +#define pte_unmap_nested(pte) do { } while (0)
> > +
> > +#define pte_unmap(pte)			do { } while (0)
> > +#define pte_unmap_nested(pte)		do { } while (0)
> > +
> > +#endif /* _PARISC_ASM_PTEMAP_H */
> 
> You have duplicate definitiosn of pte_unmap{,_nested}?

Heh.  I actually just copied this verbatim from the existing parisc
header.  It already had a duplicate. :)

Anyway, I've made sure not to copy the dup and added a note in the patch
description so that it is much more clear.  I'll show up in the next
post.  Thanks for the review!

-- Dave

