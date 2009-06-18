Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbZFRNsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbZFRNsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbZFRNsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:48:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:59167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbZFRNsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:48:46 -0400
Subject: Re: [PATCH 2/5 -tip] x86: move common typedefs to asm/posix_types.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200906181510.27464.arnd@arndb.de>
References: <1245314365.31204.7.camel@ht.satnam>
	 <1245314484.31204.10.camel@ht.satnam> <20090618115101.GA1671@infradead.org>
	 <200906181510.27464.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 19:17:25 +0530
Message-Id: <1245332845.3215.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 15:10 +0200, Arnd Bergmann wrote:
> On Thursday 18 June 2009, Christoph Hellwig wrote:
> > 
> > On Thu, Jun 18, 2009 at 02:11:24PM +0530, Jaswinder Singh Rajput wrote:
> > > 
> > > Move common typedefs to asm/posix_types.h for easy maintenance
> > 
> > I think at this point it would be cleaner to also move the differing
> > ones into asm/posix_types.h so that there's just one file to look at for
> > the types.
> 
> Agreed.
> 
> Because of the new asm-gneeric headers, you can also
> #include <asm-generic/posix_types.h> for any of the default types and
> only override the ones that are x86-specific.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 

Thanks, Arnd.

I will prepare new patch/pull-request by adding this patch.

--
JSR

