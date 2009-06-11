Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbZFKDRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbZFKDRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZFKDRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:17:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:40094 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZFKDRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:17:11 -0400
Subject: Re: linux-next: powerpc tree build warning
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <20090611113930.78a42893.sfr@canb.auug.org.au>
References: <20090611113930.78a42893.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 13:14:04 +1000
Message-Id: <1244690044.5739.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 11:39 +1000, Stephen Rothwell wrote:
> Hi Ben,
> 
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> arch/powerpc/platforms/Kconfig.cputype:60:warning: defaults for choice values not supported
> 
> We appear to have CONFIG_PPC_BOOK3S int two places which is confusing
> Kconfig.

Yes, I see that. One place depends on PPC32 and the other one PPC64, but
it still seems to be somewhat confused. In any case, it seems to still
do the right thing, so not a big hurry here, but I'll do a patch that
does it differently.

Cheers,
Ben.


