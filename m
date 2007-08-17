Return-Path: <linux-kernel-owner+w=401wt.eu-S1765500AbXHQQN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765500AbXHQQN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbXHQQNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:13:47 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:57334 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095AbXHQQNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:13:46 -0400
Date: Sat, 18 Aug 2007 01:15:01 +0900 (JST)
Message-Id: <20070818.011501.41012303.anemo@mba.ocn.ne.jp>
To: david-b@pacbell.net
Cc: jengelh@computergmbh.de, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <200708170902.01260.david-b@pacbell.net>
References: <200708170823.15894.david-b@pacbell.net>
	<Pine.LNX.4.64.0708171736170.30502@fbirervta.pbzchgretzou.qr>
	<200708170902.01260.david-b@pacbell.net>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 09:02:00 -0700, David Brownell <david-b@pacbell.net> wrote:
> Because for some reason the driver name isn't rtc-ds1742 ...
> 
> My preferred style for such patches puts the MODULE_ALIAS up
> near the strange driver name, so it's more clear what's going
> on.  Putting all the MODULE_*() stuff at the end of the file
> gets confusing in this case.

OK, then I should update my patches anyway ;)

Which do you prefer, MODULE_ALIAS or change some strings?

I guess there are some out-of-tree users of this driver, but fixing
them is really trivial, so I don't think this is a big compatibility
problem.

---
Atsushi Nemoto
