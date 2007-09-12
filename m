Return-Path: <linux-kernel-owner+w=401wt.eu-S968222AbXILMml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968222AbXILMml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966469AbXILMmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:42:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37422 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966125AbXILMmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:42:32 -0400
Date: Wed, 12 Sep 2007 14:42:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/8] Immediate Values - Kconfig menu in EMBEDDED
Message-ID: <20070912124230.GA2287@one.firstfloor.org>
References: <20070906200228.086651361@polymtl.ca> <20070906200314.692565803@polymtl.ca> <20070907064908.GG31880@one.firstfloor.org> <20070907124648.GC9735@Krystal> <20070907223950.GB22646@one.firstfloor.org> <20070911202259.GB23251@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911202259.GB23251@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, but then you would make immediate.o an obj-y (both for
> kernel/Makefile and arch/*/kernel/Makefile) and it would be built
> even on systems that would be configured not to use immediate values.

You can stick a define into generic-immediate.h and put an ifndef
for that around immediate.c

Or the recently posted function garbage collection patches would
also take care of it.

-Andi
