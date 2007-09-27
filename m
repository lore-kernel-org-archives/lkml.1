Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbXI0Ozq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbXI0Ozq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbXI0Ozi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:55:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52795 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbXI0Ozh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:55:37 -0400
Date: Thu, 27 Sep 2007 16:55:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       Oleg Verych <olecom@flower.upol.cz>, Jan Beulich <jbeulich@novell.com>,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: why network devices don't do reference counting? (Re: [PATCH]
 Module use count must be updated as bridges are created/destroyed)
In-Reply-To: <20070927075102.4335a263@freepuppy.rosehill>
Message-ID: <Pine.LNX.4.64.0709271654270.30621@fbirervta.pbzchgretzou.qr>
References: <46FA2C17.76E4.0078.0@novell.com> <20070926083705.6bc65ea5@fujitsu-loaner>
 <E1Iae5t-0007Sk-Vu@flower> <20070926140608.6e6d3d0c@freepuppy.rosehill>
 <Pine.LNX.4.64.0709270017120.17414@fbirervta.pbzchgretzou.qr>
 <20070926153330.77aade4d@freepuppy.rosehill> <46FB99EF.4020806@aitel.hist.no>
 <20070927075102.4335a263@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 27 2007 07:51, Stephen Hemminger wrote:
>
>You need every socket to close and all routes to go away including the 
>routes through loopback device, and still there probably are control 
>sockets buried inside ipv6 that hold ref count.
>
>IMHO the kernel should just admit that IPV6 can't be removed.

I cannot accept that. If ipv6.ko has a way to tack ipv6 structs onto all 
sockets, interfaces and addresses, it should also be able to untack it 
again.
