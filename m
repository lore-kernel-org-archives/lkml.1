Return-Path: <linux-kernel-owner+w=401wt.eu-S966027AbXEGR13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966027AbXEGR13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965984AbXEGR12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:27:28 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:41476 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965979AbXEGR11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:27:27 -0400
Subject: Re: [PATCH 2.6.21-mm1]  remove unionfs reference to
	SLAB_CTOR_VERIFY
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jsipek@cs.sunysb.edu,
       Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <20070507171608.GA23382@filer.fsl.cs.sunysb.edu>
References: <1178551352.5079.25.camel@localhost>
	 <20070507171608.GA23382@filer.fsl.cs.sunysb.edu>
Content-Type: text/plain; charset=UTF-8
Organization: HP/OSLO
Date: Mon, 07 May 2007 13:27:25 -0400
Message-Id: <1178558846.5079.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 13:16 -0400, Josef Sipek wrote:
> On Mon, May 07, 2007 at 11:22:32AM -0400, Lee Schermerhorn wrote:
> > With unionfs included as a module, 2.6.21-mm1 build broke with:
> > 
> > fs/unionfs/super.c: In function ‘init_once’:
> > fs/unionfs/super.c:822: error: ‘SLAB_CTOR_VERIFY’ undeclared (first use in this function)
> > fs/unionfs/super.c:822: error: (Each undeclared identifier is reported only oncefs/unionfs/super.c:822: error: for each function it appears in.)
> > 
> > Looks like it missed the removal of SLAB_CTOR_VERIFY.  
>  
> This fix (by Adrian Bunk) is already in the unionfs git tree.
> 
> Thanks anyway.

OK.  I just ran into the issue this am with 21-mm1.  I didn't see the
fix in the MARC archives, but they haven't been updated since ~3may.
Sorry for the noise...

Lee

