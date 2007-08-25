Return-Path: <linux-kernel-owner+w=401wt.eu-S1765089AbXHYGYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765089AbXHYGYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 02:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXHYGX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 02:23:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44619
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbXHYGX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 02:23:56 -0400
Date: Fri, 24 Aug 2007 23:23:55 -0700 (PDT)
Message-Id: <20070824.232355.82703897.davem@davemloft.net>
To: jesper.juhl@gmail.com
Cc: linux-kernel@vger.kernel.org, samuel@sortiz.org, a_villacis@palosanto.com
Subject: Re: [PATCH 10/30] irda: Do not do pointless kmalloc return value
 cast in KingSun driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <6d744c4594d042e63fa00469ccbfaeca54639b01.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	<6d744c4594d042e63fa00469ccbfaeca54639b01.1187912217.git.jesper.juhl@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:54:23 +0200

> kmalloc() returns a void pointer, so there is no need to cast it in
>  drivers/net/irda/kingsun-sir.c::kingsun_probe().
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Applied.
