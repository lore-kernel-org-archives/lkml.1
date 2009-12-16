Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbZLPKNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbZLPKNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761242AbZLPKNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:13:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40091 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761240AbZLPKNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:13:10 -0500
Date: Wed, 16 Dec 2009 11:13:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: hwpoison tree build failure
Message-ID: <20091216101308.GB15031@basil.fritz.box>
References: <20091216172633.93c361ee.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216172633.93c361ee.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 05:26:33PM +1100, Stephen Rothwell wrote:
> Hi Andi,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> mm/memory-failure.c: In function 'soft_offline_page':
> mm/memory-failure.c:1266: error: too few arguments to function 'migrate_pages'
> 
> Caused by commit c71d409184af558ddac0fd0167061d6282428872 ("HWPOISON: Add
> soft page offline support") from the hwpoison tree interacting with
> commit 62b61f611eb5e20f7e9f8619bfd03bdfe8af6348 ("ksm: memory hotremove
> migration only") from Linus' tree.
> 
> I added the following merge fix for today (I don't know if it is correct)
> and can carry it for a while:

Yes I am already aware of this, but I haven't pushed out a new tree yet
(mostly because there was no uptodate -git* snapshot for this yesterday, lame
excuse I know) 

Your fix is the same as I have.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
