Return-Path: <linux-kernel-owner+w=401wt.eu-S1764504AbXESUzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764504AbXESUzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 16:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbXESUzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 16:55:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60697
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758637AbXESUzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 16:55:38 -0400
Date: Sat, 19 May 2007 13:55:41 -0700 (PDT)
Message-Id: <20070519.135541.27953859.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22-rc1] net/core/skbuff.c gcc-3.2.3 compilation
 error
From: David Miller <davem@davemloft.net>
In-Reply-To: <200705181149.l4IBnxaT018994@harpo.it.uu.se>
References: <200705181149.l4IBnxaT018994@harpo.it.uu.se>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Fri, 18 May 2007 13:49:59 +0200 (MEST)

> [Resend. First message reached netdev but not linux-kernel due to Cc: typo]
> 
> Compiling 2.6.22-rc1 with gcc-3.2.3 for i486 fails with:
 ...
> The patch below implements a simple workaround which is to
> clone the offending memcpy() call and specialise it for the
> two different scenarios.
> 
> Other workarounds are of course possible: e.g. bind the varying
> parameter in a local variable, or use a macro or inline function
> to perform the varying computation.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

Applied, thanks Mikael.
