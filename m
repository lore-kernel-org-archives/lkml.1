Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbXFRJSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbXFRJSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbXFRJRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:17:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54780
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755545AbXFRJRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:17:55 -0400
Date: Mon, 18 Jun 2007 02:18:13 -0700 (PDT)
Message-Id: <20070618.021813.105401188.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I0CTH-0006k3-00@dorka.pomaz.szeredi.hu>
References: <E1I0BzQ-0006gZ-00@dorka.pomaz.szeredi.hu>
	<20070618.005711.21897961.davem@davemloft.net>
	<E1I0CTH-0006k3-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 10:20:23 +0200

> And is anyone working on a better patch?

I have no idea.

> Those patches aren't "bad" in the correctness sense.  So IMO any one
> of them is better, than having that bug in there.

You're adding a very serious performance regression, which is
about as bad as the bug itself.

It can wait for a more appropriate fix.
