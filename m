Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbXEXAR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbXEXAR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbXEXARV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:17:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42798
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756160AbXEXARV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:17:21 -0400
Date: Wed, 23 May 2007 17:17:23 -0700 (PDT)
Message-Id: <20070523.171723.68041701.davem@davemloft.net>
To: bcollins@ubuntu.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] SUNHME: Workaround ancient hang on U1's
From: David Miller <davem@davemloft.net>
In-Reply-To: <91fcd7d6a83321c37f6769164b1b41ce78a07bfa.1179964369.git.bcollins@ubuntu.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
	<91fcd7d6a83321c37f6769164b1b41ce78a07bfa.1179964369.git.bcollins@ubuntu.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Collins <bcollins@ubuntu.com>
Date: Wed, 23 May 2007 18:30:46 -0400

> This work around has been in use by almost any distribution trying to
> support sparc64 since at least 2002. Without it, sunhme hangs fairly
> quickly on UltraSPARC 1's.
> 
> Dave, I know it's not in the kernel because it isn't a "fix", but given
> that we haven't seen a fix in more than 5 years, can we get this out of my
> tree please? :)

It isn't needed any more, the hang no longer occurs.

Nobody should be applying that patch, my guess is that it was
a GCC bug that has been fixed over time that reordered the
writes to RX/TX descriptors which hung the chip.
