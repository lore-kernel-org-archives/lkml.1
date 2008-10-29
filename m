Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYJ2Nr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYJ2Nr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYJ2NrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:47:11 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43445 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbYJ2NrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:47:10 -0400
Date: Wed, 29 Oct 2008 15:45:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: =?utf-8?B?UmHDumw=?= Porcel <armin76@gentoo.org>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, klausman@gentoo.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, rth@twiddle.net
Subject: Re: [ALPHA] 2.6.28-rc fails to compile
Message-ID: <20081029134553.GA9108@cs181140183.pp.htv.fi>
References: <49083361.5060907@gentoo.org> <20081029100356.GA28224@cs181140183.pp.htv.fi> <20081029062741.7400e330@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081029062741.7400e330@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 06:27:41AM -0700, Arjan van de Ven wrote:
> 
> Andrew has a patch for this in his tree for a while... I was assuming
> he'd do a patchdump to Linus late in -rc1 but it seems not to have
> happened..

The basic problem for the Alpha build errors are circular #include's 
(that are anyway a pretty bad thing), and I'm currently attacking
that problem (it seems to be surprisingly easy).

That's IMHO better than the patch in -mm that uninlines 
pci_ioremap_bar().

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

