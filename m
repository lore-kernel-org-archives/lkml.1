Return-Path: <linux-kernel-owner+w=401wt.eu-S1761147AbXESDe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147AbXESDe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 23:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXESDeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 23:34:37 -0400
Received: from ozlabs.org ([203.10.76.45]:52032 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbXESDeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 23:34:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17998.28739.378409.440833@cargo.ozlabs.ibm.com>
Date: Sat, 19 May 2007 13:34:27 +1000
From: Paul Mackerras <paulus@samba.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, Dave Liu <r63238@freescale.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
In-Reply-To: <464DAD06.2060504@ru.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	<f9afbdb49bc1f935153305315770bccd@kernel.crashing.org>
	<464CB071.5050504@ru.mvista.com>
	<9095839480a9686d9c40aa6143edb804@kernel.crashing.org>
	<464CB460.40905@ru.mvista.com>
	<97d47c2261fe9cd3f1a6c864278a6ab6@kernel.crashing.org>
	<1179464690.32247.370.camel@localhost.localdomain>
	<1179466769.3658.0.camel@localhost.localdomain>
	<1179472096.32247.394.camel@localhost.localdomain>
	<464DAD06.2060504@ru.mvista.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov writes:

>     Yeah, the classic decrementer is programmed off-by-one.

Actually it's programmed off by slightly less than one half on
average, but it doesn't matter since the error doesn't accumulate.

Paul.
