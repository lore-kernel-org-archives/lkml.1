Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbXFOMK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbXFOMK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbXFOMKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:10:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbXFOMKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:10:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200706151355.57464.ak@suse.de>
References: <200706151355.57464.ak@suse.de> <200706150159.l5F1xNgM000459@hera.kernel.org> <200706151128.39566.arnd@arndb.de> <200706151131.38429.arnd@arndb.de>
To: Andi Kleen <ak@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Fri, 15 Jun 2007 13:09:17 +0100
Message-ID: <5717.1181909357@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> wrote:

> Why does it break them? It should just make them a little slower.

Not all CPUs deliver recoverable misalignment exceptions.  This is probably
particularly true of NOMMU-mode archs where the CPU designed may have taken
the view that if a data exception is delivered, then the whole system is kaput
anyway and must be restarted.

> The network code requires unaligned accesses to work anyways so if your
> architecture doesn't support them it is already remotely crashable.

I thought we'd fixed all that.

David
