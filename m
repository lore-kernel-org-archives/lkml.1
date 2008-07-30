Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYG3Wka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYG3Wka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYG3WkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:40:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53998
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753822AbYG3WkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:40:17 -0400
Date: Wed, 30 Jul 2008 15:40:17 -0700 (PDT)
Message-Id: <20080730.154017.10423102.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1] sparc64: FUTEX_OP_ANDN fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <200807302214.m6UMEw7l000936@harpo.it.uu.se>
References: <200807302214.m6UMEw7l000936@harpo.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Thu, 31 Jul 2008 00:14:58 +0200 (MEST)

> Correct sparc64's implementation of FUTEX_OP_ANDN to do a
> bitwise negate of the oparg parameter before applying the
> AND operation. All other archs that support FUTEX_OP_ANDN
> either negate oparg explicitly (frv, ia64, mips, sh, x86),
> or do so indirectly by using an and-not instruction (powerpc).
> Since sparc64 has and-not, I chose to use that solution.
> 
> I've not found any use of FUTEX_OP_ANDN in glibc so the
> impact of this bug is probably minor. But other user-space
> components may try to use it so it should still get fixed.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

Thanks a lot for this fix, I'll apply it!
