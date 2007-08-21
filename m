Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbXHUHNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbXHUHNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbXHUHN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:13:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52039
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbXHUHNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:13:25 -0400
Date: Tue, 21 Aug 2007 00:13:23 -0700 (PDT)
Message-Id: <20070821.001323.55483148.davem@davemloft.net>
To: konstantin.sharlaimov@gmail.com
Cc: msuresh_2001@yahoo.com, paulus@samba.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22.3] ppp: fix output buffer size in
 ppp_decompress_frame
From: David Miller <davem@davemloft.net>
In-Reply-To: <1187343951.10629.9.camel@traveler>
References: <1187343951.10629.9.camel@traveler>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Date: Fri, 17 Aug 2007 20:45:51 +1100

> This patch addresses the issue with "osize too small" errors in mppe encryption.
> The patch fixes the issue with wrong output buffer size being passed to ppp
> decompression routine.
> 
> Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
> ---
> As pointed out by Suresh Mahalingam, the issue addressed by 
> ppp-fix-osize-too-small-errors-when-decoding patch is not fully resolved yet.
> The size of allocated output buffer is correct, however it size passed to
> ppp->rcomp->decompress in ppp_generic.c if wrong. The patch fixes that.

Patch applied, thanks.
