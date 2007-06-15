Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbXFOMyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbXFOMyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbXFOMyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:54:39 -0400
Received: from mx1.suse.de ([195.135.220.2]:48049 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbXFOMyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:54:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 14:54:28 +0200
User-Agent: KMail/1.9.6
Cc: David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706151355.57464.ak@suse.de> <200706151443.13511.ak@suse.de> <20070615135420.7fe2e4c1@the-village.bc.nu>
In-Reply-To: <20070615135420.7fe2e4c1@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151454.28854.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 14:54:20 Alan Cox wrote:

> > > > The network code requires unaligned accesses to work anyways so if your
> > > > architecture doesn't support them it is already remotely crashable.
> > >
> > > I thought we'd fixed all that.
> > 
> > Did you audit the complete network stack?
> 
> For the parts used by the processors in question yes 

That means? They're expected to run only a subset of the network stack?
Is that expressed in Kconfig? Is it documented that the rest is dangerous?

> people have done 
> that work so using the types without unaligned.

Very brave; we're talking about around half a million lines
of non trivial source code here.

-Andi

