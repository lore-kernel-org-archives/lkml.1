Return-Path: <linux-kernel-owner+w=401wt.eu-S966032AbXEGRQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966032AbXEGRQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966024AbXEGRQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:16:50 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46402 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966022AbXEGRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:16:49 -0400
Date: Mon, 7 May 2007 13:16:08 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jsipek@cs.sunysb.edu,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH 2.6.21-mm1]  remove unionfs reference to SLAB_CTOR_VERIFY
Message-ID: <20070507171608.GA23382@filer.fsl.cs.sunysb.edu>
References: <1178551352.5079.25.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1178551352.5079.25.camel@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 11:22:32AM -0400, Lee Schermerhorn wrote:
> With unionfs included as a module, 2.6.21-mm1 build broke with:
> 
> fs/unionfs/super.c: In function ‘init_once’:
> fs/unionfs/super.c:822: error: ‘SLAB_CTOR_VERIFY’ undeclared (first use in this function)
> fs/unionfs/super.c:822: error: (Each undeclared identifier is reported only oncefs/unionfs/super.c:822: error: for each function it appears in.)
> 
> Looks like it missed the removal of SLAB_CTOR_VERIFY.  
 
This fix (by Adrian Bunk) is already in the unionfs git tree.

Thanks anyway.

Josef "Jeff" Sipek.

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are, by
definition, not smart enough to debug it.
		- Brian W. Kernighan 
