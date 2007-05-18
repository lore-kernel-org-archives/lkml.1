Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXERXuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXERXuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbXERXuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:50:00 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:57096 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755003AbXERXuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:50:00 -0400
In-Reply-To: <1179530872.32247.423.camel@localhost.localdomain>
References: <200705172142.26739.sshtylyov@ru.mvista.com> <f9afbdb49bc1f935153305315770bccd@kernel.crashing.org> <464CB071.5050504@ru.mvista.com> <9095839480a9686d9c40aa6143edb804@kernel.crashing.org> <464CB460.40905@ru.mvista.com> <97d47c2261fe9cd3f1a6c864278a6ab6@kernel.crashing.org> <1179464690.32247.370.camel@localhost.localdomain> <1179466769.3658.0.camel@localhost.localdomain> <1179472096.32247.394.camel@localhost.localdomain> <464DAD06.2060504@ru.mvista.com> <1179530872.32247.423.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <51b3a75638604c9dd7ed60a10f0ed934@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Dave Liu <r63238@freescale.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Date: Sat, 19 May 2007 01:49:59 +0200
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I find it extremely silly to implement it as edge anyway. The EE line 
> is
> level triggered, and having a mix of edge and level on the same
> exception without a clean way to retrigger the DEC one other than
> waiting one tick is just causing trouble.

It isn't edge triggered, it just automatically clears the
decrementer exception condition at its source when taken
(on certain implementations -- others leave it to software
to clear it).


Segher

