Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbYGXJXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbYGXJXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYGXJXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:23:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50097
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbYGXJW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:22:59 -0400
Date: Thu, 24 Jul 2008 02:22:59 -0700 (PDT)
Message-Id: <20080724.022259.113079007.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: mingo@elte.hu, w@1wt.eu, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi
Subject: Re: [TCP bug, regression] stuck distcc connections in latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1KLwlD-0001Ub-00@gondolin.me.apana.org.au>
References: <20080724060448.GA10203@elte.hu>
	<E1KLwlD-0001Ub-00@gondolin.me.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW, if someone can contact the Fedora folks, specifically whoever
added that syncookies enable to /etc/sysctl.conf, and let them know
that they've set our TCP stack back by 10 years by disabling SACK
and timestamps, I'd really appreciate it.
