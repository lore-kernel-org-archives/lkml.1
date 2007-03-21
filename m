Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXCUQbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXCUQbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXCUQbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:31:01 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51825 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbXCUQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:31:00 -0400
Date: Wed, 21 Mar 2007 09:30:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Tasos Parisinos <t.parisinos@sciensis.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][NEW] crypto API: rsa algorithm module patch (kernel
 version 2.6.20.3)
Message-Id: <20070321093029.5668cd99.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0703211207170.7576@localhost.localdomain>
References: <Pine.LNX.4.64.0703211701260.27640@zenon.ceid.upatras.gr>
	<20070321090420.f46cef4f.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0703211207170.7576@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 12:08:58 -0400 (EDT) Robert P. J. Day wrote:

> On Wed, 21 Mar 2007, Randy Dunlap wrote:
> 
> > On Wed, 21 Mar 2007 17:13:31 +0200 (EET) Tasos Parisinos wrote:
> 
> > > +/*
> > > + * mpi_alloc - allocate an mpi
> > > + * @n: pointer pointer to the allocated mpi
> > > + * @limbs: number of allocated limbs (32 bit digits)
> > > + *
> > > + * The allocated mpi will be zeroed and not canonicalized
> > > + */
> 
> 
> if this is extractable kernel doc content, shouldn't it begin with
> "/**" rather than just "/*"?

Yes, so it's not extractable.  However, I also asked which functions
are meant to be exported, and those are the ones that really need to
be in kernel-doc format IMO.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
