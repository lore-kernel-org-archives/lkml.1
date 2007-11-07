Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbXKGJ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbXKGJ3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbXKGJ3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:29:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45348
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753246AbXKGJ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:29:07 -0500
Date: Wed, 07 Nov 2007 01:29:06 -0800 (PST)
Message-Id: <20071107.012906.171422435.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3]: tty - fix network driver interactions with
 TCGET/SET calls
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071102153329.1a236477@the-village.bc.nu>
References: <20071102153329.1a236477@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 2 Nov 2007 15:33:29 +0000

> Dave Miller noted various cases where line disciplines for things like
> ppp go poking around in termios themselves in ways that broke with the
> new termios code. Rather than have them all learning about termios
> internals provide proper methods for this
> 
> - tty_mode_ioctl()
> 
> 	This handles all the terminal mode handling for speed/carrier etc
> and none of the methods are ldisc dependant so they can be called by any
> user
> 
> - tty_perform_flush()
> 
> 	This extracts the flush functionality and enables pppd the ppp
> layer to share it cleanly.
> 
> 
> The existing n_tty_ioctl code is refactored in this patch to provide the
> new functions and to call them itself appropriately. This patch has no
> (intended) behaviour changes and simply prepares for the other fixes.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Patch applied.
