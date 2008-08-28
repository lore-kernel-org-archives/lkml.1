Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYH1CEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYH1CEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 22:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYH1CEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 22:04:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44186
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753266AbYH1CEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 22:04:14 -0400
Date: Wed, 27 Aug 2008 19:04:09 -0700 (PDT)
Message-Id: <20080827.190409.80969099.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: sparc build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080828114602.6c6df4a2.sfr@canb.auug.org.au>
References: <20080828114602.6c6df4a2.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 28 Aug 2008 11:46:02 +1000

> Linus' tree fails to build for sparc32 allmodconfig:
> 
> kernel/relay.c:701: undefined reference to `smp_call_function_single'
> 
> This is because it has CONFIG_SMP but not CONFIG_USE_GENERIC_SMP_HELPERS.
> 
> I am not sure what to do about this.

I'll try to come up with a fix for this, thanks.
