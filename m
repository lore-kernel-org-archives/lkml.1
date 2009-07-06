Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbZGFT3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbZGFT3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZGFT3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:29:05 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:46440 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZGFT3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:29:04 -0400
From: Christian Lamparter <chunkeey@web.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] p54: Fix regression in 2.6.31-rcX since commit a1091aa - sleeping function called from invalid context
Date: Mon, 6 Jul 2009 21:19:25 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc1-wl; KDE/4.2.4; x86_64; ; )
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <4a524b55.wIWqgs5uHs2CpdJy%Larry.Finger@lwfinger.net> <20090706.121429.36217952.davem@davemloft.net>
In-Reply-To: <20090706.121429.36217952.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907062119.25642.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX18QOUiLhQteDwHwsH3D6jWMDMrQWBA84nOmlWgq
	IjDPklc5sUu1UVo6dPwy5mIhC8XfguZHQseKOdFLdin8IzG87F
	+pXHEF/tY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 July 2009 21:14:29 David Miller wrote:
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Mon, 06 Jul 2009 14:07:01 -0500
> 
> > Beginning with commit a1091aae19b1d9c85d91c86915a611387f67a26b entitled
> > "p54: Use SKB list handling helpers instead of by-hand code.", the following
> > appears in my logs whenever I try to use my p54usb wireless device:
> > 
> > BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1085
> 
> Thanks for tracking this down Larry.  I'll have a closer look.
> 
> If I can't figure it out quickly I'll just simply revert.
hmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
[2.6.31] p54: band-aid to restore driver functionality
http://patchwork.ozlabs.org/patch/28918/

in case someone missed it.

Regards,
	Chr
