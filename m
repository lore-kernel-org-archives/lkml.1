Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXFOMoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXFOMoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbXFOMnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:43:53 -0400
Received: from ns.suse.de ([195.135.220.2]:47409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbXFOMnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:43:51 -0400
From: Andi Kleen <ak@suse.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 14:43:12 +0200
User-Agent: KMail/1.9.1
Cc: Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706151355.57464.ak@suse.de> <200706151131.38429.arnd@arndb.de> <5717.1181909357@redhat.com>
In-Reply-To: <5717.1181909357@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706151443.13511.ak@suse.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 une 2007 14:09, David Howells wrote:
> Andi Kleen <ak@suse.de> wrote:
> > Why does it break them? It should just make them a little slower.
>
> Not all CPUs deliver recoverable misalignment exceptions.  

These CPUs are too broken to run Linux then.

> > The network code requires unaligned accesses to work anyways so if your
> > architecture doesn't support them it is already remotely crashable.
>
> I thought we'd fixed all that.

Did you audit the complete network stack?

-Andi
