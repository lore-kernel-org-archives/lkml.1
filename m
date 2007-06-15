Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbXFOJzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbXFOJzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXFOJzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:55:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41495
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbXFOJzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:55:05 -0400
Date: Fri, 15 Jun 2007 02:55:22 -0700 (PDT)
Message-Id: <20070615.025522.36921451.davem@davemloft.net>
To: arnd@arndb.de
Cc: benh@kernel.crashing.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
From: David Miller <davem@davemloft.net>
In-Reply-To: <200706151131.38429.arnd@arndb.de>
References: <1181897905.26853.66.camel@localhost.localdomain>
	<200706151128.39566.arnd@arndb.de>
	<200706151131.38429.arnd@arndb.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 15 Jun 2007 11:31:37 +0200

> One common problem with 32 bit system call and ioctl emulation
> is the different alignment rules between i386 and 64 bit machines.
> A number of drivers work around this by marking the compat
> structures as 'attribute((packed))', which is not the right
> solution because it breaks all the non-x86 architectures that
> want to use the same compat code.
> 
> Hopefully, this patch improves the situation, it introduces two
> new types, compat_u64 and compat_s64. These are defined on all
> architectures to have the same size and alignment as the 32 bit
> version of u64 and s64.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: David S. Miller <davem@davemloft.net>
