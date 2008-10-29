Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYJ2N7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYJ2N7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYJ2N7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:59:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:39167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbYJ2N7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:59:21 -0400
Date: Wed, 29 Oct 2008 06:59:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: =?UTF-8?B?UmHDumw=?= Porcel <armin76@gentoo.org>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, klausman@gentoo.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, rth@twiddle.net
Subject: Re: [ALPHA] 2.6.28-rc fails to compile
Message-ID: <20081029065935.7a5930f9@infradead.org>
In-Reply-To: <20081029134553.GA9108@cs181140183.pp.htv.fi>
References: <49083361.5060907@gentoo.org>
	<20081029100356.GA28224@cs181140183.pp.htv.fi>
	<20081029062741.7400e330@infradead.org>
	<20081029134553.GA9108@cs181140183.pp.htv.fi>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 15:45:53 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, Oct 29, 2008 at 06:27:41AM -0700, Arjan van de Ven wrote:
> > 
> > Andrew has a patch for this in his tree for a while... I was
> > assuming he'd do a patchdump to Linus late in -rc1 but it seems not
> > to have happened..
> 
> The basic problem for the Alpha build errors are circular #include's 
> (that are anyway a pretty bad thing), and I'm currently attacking
> that problem (it seems to be surprisingly easy).
> 
> That's IMHO better than the patch in -mm that uninlines 
> pci_ioremap_bar().

and in my opinion the uninline is nicer ;)
Because that means we can add more checks to it over time without
bloating the kernel.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
