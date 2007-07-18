Return-Path: <linux-kernel-owner+w=401wt.eu-S1763400AbXGRKEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763400AbXGRKEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXGRKEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:04:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60599
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752260AbXGRKEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:04:41 -0400
Date: Wed, 18 Jul 2007 03:04:40 -0700 (PDT)
Message-Id: <20070718.030440.124084796.davem@davemloft.net>
To: kaber@trash.net
Cc: crquan@gmail.com, netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
       pekkas@netcore.fi, jmorris@namei.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [net/core] move dev_mc_discard from dev_mcast.c to
 dev.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <469DE502.8070800@trash.net>
References: <20070718.021107.40833440.davem@davemloft.net>
	<91b13c310707180259v547ba2b3wc901102d35760a50@mail.gmail.com>
	<469DE502.8070800@trash.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 18 Jul 2007 12:01:38 +0200

> rae l wrote:
> > All in one word, I don't think the single file dev_mcast.c is needed
> > anymore.
> 
> Agreed. But dev.c is growing larger and larger, maybe dev_addr.c?
> Or dev_config.c, with some of the other device configuration functions?

I don't know, a sizable dev.c is inevitable, allows better refactoring
and consolidation.  And the be honest you're going to have to likely
touch things in dev.c whenever you make changes to dev_addr.c or
whatever you want to name it. :-)

