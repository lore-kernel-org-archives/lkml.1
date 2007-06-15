Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbXFOXzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbXFOXzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbXFOXzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:55:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:53945 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbXFOXzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:55:36 -0400
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070615134512.GG8154@parisc-linux.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org>
	 <200706151131.38429.arnd@arndb.de> <20070615121133.GF8154@parisc-linux.org>
	 <200706151442.23939.arnd@arndb.de> <20070615134512.GG8154@parisc-linux.org>
Content-Type: text/plain
Date: Sat, 16 Jun 2007 09:54:22 +1000
Message-Id: <1181951662.26853.97.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 07:45 -0600, Matthew Wilcox wrote:

> 
> $ ./test 
> offset of foo->x is 8
> offset of bar->x is 4

Looks to me like bar (that is compat_s64) is doing the right thing, no ?

Ben.


