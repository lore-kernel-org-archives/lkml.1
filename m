Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZGFTOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZGFTOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZGFTOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:14:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38053
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbZGFTOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:14:22 -0400
Date: Mon, 06 Jul 2009 12:14:29 -0700 (PDT)
Message-Id: <20090706.121429.36217952.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org, chunkeey@web.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54: Fix regression in 2.6.31-rcX since commit a1091aa
 - sleeping function called from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <4a524b55.wIWqgs5uHs2CpdJy%Larry.Finger@lwfinger.net>
References: <4a524b55.wIWqgs5uHs2CpdJy%Larry.Finger@lwfinger.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 06 Jul 2009 14:07:01 -0500

> Beginning with commit a1091aae19b1d9c85d91c86915a611387f67a26b entitled
> "p54: Use SKB list handling helpers instead of by-hand code.", the following
> appears in my logs whenever I try to use my p54usb wireless device:
> 
> BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1085

Thanks for tracking this down Larry.  I'll have a closer look.

If I can't figure it out quickly I'll just simply revert.
