Return-Path: <linux-kernel-owner+w=401wt.eu-S1161029AbXCGAbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbXCGAbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030766AbXCGAbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:31:50 -0500
Received: from ozlabs.org ([203.10.76.45]:53144 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161054AbXCGA3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:29:52 -0500
Subject: Re: [PATCH 6/8] Allow per-cpu variables to be page-aligned
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <45EDB057.5080106@goop.org>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
	 <1173185827.4644.34.camel@localhost.localdomain>
	 <1173185909.4644.36.camel@localhost.localdomain>
	 <1173186021.4644.38.camel@localhost.localdomain>
	 <45EDB057.5080106@goop.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 11:29:10 +1100
Message-Id: <1173227351.4644.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 10:17 -0800, Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > diff -r 213b1ec27001 arch/alpha/kernel/vmlinux.lds.S
> > --- a/arch/alpha/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
> > +++ b/arch/alpha/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
> > @@ -69,7 +69,7 @@ SECTIONS
> >    . = ALIGN(8);
> >    SECURITY_INIT
> >  
> > -  . = ALIGN(64);
> > +  . = ALIGN(8192);
> >   
> 
> Isn't there a PAGE_SIZE we can use here?  PAGE_SIZE_asm?
> (ditto all archs)

Probably, but I carefully copied the style from other parts of the same
file for the same arch.  So, that cleanup would be another patch 8)

Rusty.


