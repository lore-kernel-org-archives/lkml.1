Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbZHTERZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbZHTERZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 00:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZHTERZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 00:17:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60550
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbZHTERY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 00:17:24 -0400
Date: Wed, 19 Aug 2009 21:17:36 -0700 (PDT)
Message-Id: <20090819.211736.222582824.davem@davemloft.net>
To: walt@holmansrus.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, khc@pm.waw.pl
Subject: Re: Strange network timeouts w/ 2.6.30.5
From: David Miller <davem@davemloft.net>
In-Reply-To: <2087985663.21250727676944.JavaMail.root@mail.holmansrus.com>
References: <1762204735.01250727555803.JavaMail.root@mail.holmansrus.com>
	<2087985663.21250727676944.JavaMail.root@mail.holmansrus.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Walt Holman <walt@holmansrus.com>
Date: Wed, 19 Aug 2009 19:21:16 -0500 (CDT)

Fixing the broken CC: list, it's "netdev" not "linux-netdev".

> Since patching to 2.6.30.5 I'm experiencing periodic timeouts on my e100 which is used as my WAN interface on a server/router box. Nothing is reported in any logs and eventually the traffic resumes. It seems to happen at fairly regular intervals, although I've not timed them. The timeouts last for approx. 60-120 seconds and then traffic resumes normally with no hint of what happened. 
> 
> Reverting commit 303d67c288319768b19ed8dbed429fef7eb7c275 allows traffic to flow freely again. Attaching .config & lspci, anything else you need? 
> 
> -Walt
