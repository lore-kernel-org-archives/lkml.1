Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbYD3Br6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbYD3Br6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYD3Brt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:47:49 -0400
Received: from lixom.net ([66.141.50.11]:44538 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbYD3Brs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:47:48 -0400
Date: Tue, 29 Apr 2008 21:01:27 -0500
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hitoshi Mitake <h.mitake@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: upstream build failure: pasemi_edac
Message-ID: <20080430020127.GB19958@lixom.net>
References: <20080430111949.fc148fac.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430111949.fc148fac.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 11:19:49AM +1000, Stephen Rothwell wrote:

> Caused by commit c3c52bce6993c6d37af2c2de9b482a7013d646a7 ("edac: fix
> module initialization on several modules 2nd time") which added a call to
> opstate_init but did not include linux/edac.h that declares it.

Grmbl. Thanks for finding it.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 30 Apr 2008 11:16:16 +1000
> Subject: [PATCH] pasemi_edac needs to include linux/edac.h
> 
> Commit c3c52bce6993c6d37af2c2de9b482a7013d646a7 ("edac: fix module
> initialization on several modules 2nd time") added a call to opstate_init
> but did not include linux/edac.h that declares it.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Olof Johansson <olof@lixom.net>

