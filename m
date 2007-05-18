Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbXERFjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbXERFjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 01:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXERFji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 01:39:38 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:56941 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbXERFji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 01:39:38 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Dave Liu <r63238@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1179464690.32247.370.camel@localhost.localdomain>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <f9afbdb49bc1f935153305315770bccd@kernel.crashing.org>
	 <464CB071.5050504@ru.mvista.com>
	 <9095839480a9686d9c40aa6143edb804@kernel.crashing.org>
	 <464CB460.40905@ru.mvista.com>
	 <97d47c2261fe9cd3f1a6c864278a6ab6@kernel.crashing.org>
	 <1179464690.32247.370.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 18 May 2007 13:39:29 +0800
Message-Id: <1179466769.3658.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-3) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 May 2007 05:39:30.0177 (UTC) FILETIME=[E7DA1710:01C7990E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, on some implementations there can be other conditions that
> > make a decrementer exception go away; there is no contradiction
> > here (thankfully).  My wording was sloppy.
> 
> Some CPUs have the DEC exceptions basically edge triggered (yeah I know

for example?

> it sucks). That's why, among others, the IRQ soft-disable code has code
> to re-trigger DEC exceptions ASAP (by setting it to 1.. note that we
> could probably use 0 here, we've been a bit conservative).


