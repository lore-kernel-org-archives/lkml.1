Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYJGS07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYJGS07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYJGS0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:26:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33422
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbYJGS0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:26:47 -0400
Date: Tue, 07 Oct 2008 11:26:22 -0700 (PDT)
Message-Id: <20081007.112622.73930718.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: minyard@acm.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <48EAF29D.8050203@cosmosbay.com>
References: <48EA8197.6080502@cosmosbay.com>
	<20081006.144002.56418911.davem@davemloft.net>
	<48EAF29D.8050203@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Tue, 07 Oct 2008 07:24:45 +0200

> Most UDP sockets are setup for long periods (RTP trafic), or if an application really
> wants to {open/send or receive one UDP frame/close} many sockets, it already hits
> RCU handling of its file structures and should not be slowed down that much.

As stated, I added RCU destruction generically for socket objects, and it
showed up clearly.

So "not be slowed down that much" has been disproven, at least to me,
already :-)
