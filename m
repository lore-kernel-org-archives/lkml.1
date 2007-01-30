Return-Path: <linux-kernel-owner+w=401wt.eu-S965423AbXA3H4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965423AbXA3H4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 02:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965433AbXA3H4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 02:56:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:37507 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965423AbXA3H4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 02:56:08 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for
	profiling Cell BE SPUs -- update
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, maynardj@us.ibm.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
In-Reply-To: <200701300839.05144.arnd@arndb.de>
References: <45BE4ED0.5030808@us.ibm.com> <45BE4FA4.9020105@us.ibm.com>
	 <200701300839.05144.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 18:53:50 +1100
Message-Id: <1170143630.26655.326.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > +/* Defines used for sync_start */
> > +#define SKIP_GENERIC_SYNC 0
> > +#define SYNC_START_ERROR -1
> > +#define DO_GENERIC_SYNC 1
> > +
> > +typedef struct vma_map
> > +{
> > +       struct vma_map *next;
> > +       unsigned int vma;
> > +       unsigned int size;
> > +       unsigned int offset;
> > +       unsigned int guard_ptr;
> > +       unsigned int guard_val;
> > +} vma_map_t;

I haven't had time to look in details yet but in that context, what does
"vma" stands for ? There's already an important vm data structure in
linux routinely called "vma" and thus I suspect this is a poor naming
choice as it will cause confusion.

Cheers,
Ben.


