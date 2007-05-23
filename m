Return-Path: <linux-kernel-owner+w=401wt.eu-S1762604AbXEWHQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604AbXEWHQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXEWHQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:16:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40872
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763423AbXEWHQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:16:22 -0400
Date: Wed, 23 May 2007 00:16:24 -0700 (PDT)
Message-Id: <20070523.001624.112047445.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce CONFIG_VIRT_TO_BUS
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070523070450.GN4095@ftp.linux.org.uk>
References: <20070523170155.2cb9eff8.sfr@canb.auug.org.au>
	<20070523070450.GN4095@ftp.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 23 May 2007 08:04:50 +0100

> On Wed, May 23, 2007 at 05:01:55PM +1000, Stephen Rothwell wrote:
> > Make some offending drivers depend on it and set
> > CONFIG_ARCH_NO_VIRT_TO_BUS for ppc64 so that we don't build those drivers.
> 
> Seeing how few targets _do_ have that, I'd invert the that.  I.e. have
> HAS_VIRT_TO_BUS in arch/*/Kconfig for the few architectures that have
> that stuff.

Great idea.
