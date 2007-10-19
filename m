Return-Path: <linux-kernel-owner+w=401wt.eu-S966732AbXJSJVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966732AbXJSJVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXJSJU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:20:57 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:49548 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbXJSJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:20:57 -0400
Subject: Re: 2.6.23-mm1 s390 driver problem
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       cornelia.huck@de.ibm.com, heiko.carstens@de.ibm.com, sam@ravnborg.org,
       Linux Containers <containers@lists.osdl.org>
In-Reply-To: <471875E0.8040308@fr.ibm.com>
References: <20071018200148.GA14234@vino.hallyn.com>
	 <200710182215.56428.borntraeger@de.ibm.com>
	 <20071018203151.GA15382@vino.hallyn.com>
	 <1192780036.25150.7.camel@localhost>  <471875E0.8040308@fr.ibm.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 19 Oct 2007 11:20:53 +0200
Message-Id: <1192785653.25150.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 11:16 +0200, Cedric Le Goater wrote:
> > This is the vmlinux.lds.S problem. The cleanup patch from Sam Ravnborg
> > moved the __initramfs_start and __initramfs_end symbols into
> > the .init.ramfs section. This is in itself not a problem, but it
> > surfaced a bug: there is no *(.init.initramfs), that needs to be
> > *(init.ramfs). I corrected this in the upstream patch but 2.6.23-mm1 has
> > the older one that still causes the "Cannot open root device". For
> > 2.6.23-mm1 use the patch below.
> > 
> 
> thanks martin, 
> 
> that helped going a little further in the boot process but we then have 
> a network issue when bringing the network interface up :

See http://marc.info/?l=linux-kernel&m=119270398931208&w=2
 
-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


