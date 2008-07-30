Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYG3ICt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYG3ICt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYG3ICg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:02:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35520
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbYG3ICf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:02:35 -0400
Date: Wed, 30 Jul 2008 01:02:34 -0700 (PDT)
Message-Id: <20080730.010234.193703201.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, sam@ravnborg.org, geert@linux-m68k.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: m68k build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080730175233.02dbf021.sfr@canb.auug.org.au>
References: <20080730175233.02dbf021.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 30 Jul 2008 17:52:33 +1000

> linux-next (version next-20080729) build (m68k defconfig) failed like this;
> 
> In file included from arch/m68k/sun3/idprom.c:16:
> include2/asm/idprom.h:3:30: error: asm-sparc/idprom.h: No such file or directory

Yes, Sam told the m68k folks this would happen and that they
would need to resolve it somehow.

Perhaps as a quick fix we can just copy sparc's idprom.h into
asm-m68k/idprom.h

