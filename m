Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYKGEto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYKGEto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYKGEtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:49:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47572
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbYKGEta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:49:30 -0500
Date: Thu, 06 Nov 2008 20:49:29 -0800 (PST)
Message-Id: <20081106.204929.161401868.davem@davemloft.net>
To: swmike@swm.pp.se
Cc: daniel.blueman@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.1.10.0811070529550.10993@uplift.swm.pp.se>
References: <alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se>
	<20081105.151015.206163697.davem@davemloft.net>
	<alpine.DEB.1.10.0811070529550.10993@uplift.swm.pp.se>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Abrahamsson <swmike@swm.pp.se>
Date: Fri, 7 Nov 2008 05:46:28 +0100 (CET)

> I see that in
> <http://www.icir.org/floyd/papers/draft-ietf-tsvwg-tcp-ecn-00.txt>
> there is a recommendation to not use ECN on retransmits, is there
> code right now (or planned) to do some kind of "ECN blackhole
> detection", ie if no response is received to SYN with ECN set,
> continue by sending the second SYN without ECN and keep this
> information for the duration of the TCP session?

No, we are firmly against any form of ECN blackhole detection.  Alexey Kuznetsov and
Sally Floyd argued this out exhaustively several years ago.
