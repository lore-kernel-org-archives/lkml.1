Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZAFQ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZAFQ3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZAFQ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:29:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57964
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbZAFQ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:29:12 -0500
Date: Tue, 06 Jan 2009 08:29:13 -0800 (PST)
Message-Id: <20090106.082913.97432854.davem@davemloft.net>
To: mingo@elte.hu
Cc: sam@ravnborg.org, kosaki.motohiro@jp.fujitsu.com, yinghai@kernel.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: irqnr fallout in gpiolib on sparc32
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090106125704.GC20407@elte.hu>
References: <20090105135508.GB4190@elte.hu>
	<20090105.123734.137888898.davem@davemloft.net>
	<20090106125704.GC20407@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 6 Jan 2009 13:57:04 +0100

> Sparc32 on the other hand had a clean IRQ layer long before x86 found its 
> desire for a clean genirq layer - so genirq is a nuisance for Sparc32 at 
> best and it deserves none of the not nice actions. What i am hoping for is 
> that perhaps the Sparc unification changed that equation.

Not really, the unificiation didn't change much in this area.  That
doesn't change the fact that I do intend to genirq'ify sparc32 some
time soon. :-)
