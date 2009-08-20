Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbZHTJNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbZHTJNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 05:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZHTJNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 05:13:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41876
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbZHTJNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 05:13:18 -0400
Date: Thu, 20 Aug 2009 02:13:30 -0700 (PDT)
Message-Id: <20090820.021330.151477484.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: walt@holmansrus.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Strange network timeouts w/ 2.6.30.5
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3my5ueu2a.fsf@intrepid.localdomain>
References: <2087985663.21250727676944.JavaMail.root@mail.holmansrus.com>
	<20090819.211736.222582824.davem@davemloft.net>
	<m3my5ueu2a.fsf@intrepid.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 20 Aug 2009 11:03:09 +0200

> The root problem is that the driver shouldn't use streaming allocations
> for its descriptors (they are written from both sides simultaneously).
> Only skb->data can be streaming.

skb->data is where e100 puts it's descriptors. :-)

But you know that.
