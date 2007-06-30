Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbXF3Ifg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbXF3Ifg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 04:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXF3If3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 04:35:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:14723 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbXF3If2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 04:35:28 -0400
Date: Sat, 30 Jun 2007 10:35:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andreas Steinmetz <ast@domdv.de>
cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
Subject: Re: mss to pmtu clamping partially broken?
In-Reply-To: <4684E853.20900@domdv.de>
Message-ID: <Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
References: <4684E853.20900@domdv.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 29 2007 13:09, Andreas Steinmetz wrote:
>
>There seems to be a problem with mss to pmtu clamping for incoming syn
>packets on reply to an outgoing connection on a ppp interface. The mss
>of the outgoing syn packets is always always clamped to the pmtu, I did
>check this with a target host I do have access to. The incoming syn
>reply to such a packet, however, is mss clamped only sometimes and this
>seems to depend on the DSL line used.

Do you really need clamping? It's a hack, since TCP should do MSS negotiation
itself. (Of course it may happen that some routers are broken.) But usually not
for incoming packets.



	Jan
-- 
