Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbXGBRET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbXGBRET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 13:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXGBREN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 13:04:13 -0400
Received: from hermes.domdv.de ([193.102.202.1]:2129 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbXGBREM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 13:04:12 -0400
Message-ID: <4689300C.9050802@domdv.de>
Date: Mon, 02 Jul 2007 19:04:12 +0200
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
Subject: Re: mss to pmtu clamping partially broken?
References: <4684E853.20900@domdv.de> <Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Do you really need clamping? It's a hack, since TCP should do MSS negotiation
> itself. (Of course it may happen that some routers are broken.) But usually not
> for incoming packets.

You never know when you hit ICMP blackholes, broken routers and other
evil things. Better safe than sorry so clamping is the way to go for me.

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
