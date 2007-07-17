Return-Path: <linux-kernel-owner+w=401wt.eu-S937082AbXGQXbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937082AbXGQXbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbXGQXbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:31:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39946 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402AbXGQXbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:31:13 -0400
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
From: Arjan van de Ven <arjan@infradead.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
In-Reply-To: <Pine.LNX.4.58.0707172334210.2141@be1.lrz>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
	 <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>
	 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
	 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>  <469BF104.1040703@gmail.com>
	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	 <469BF768.6040200@gmail.com> <Pine.LNX.4.58.0707170143200.29868@be1.lrz>
	 <469C0D32.2090102@gmail.com> <Pine.LNX.4.58.0707171119050.2210@be1.lrz>
	 <469CD456.801@gmail.com>  <Pine.LNX.4.58.0707172334210.2141@be1.lrz>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 17 Jul 2007 16:29:59 -0700
Message-Id: <1184714999.2691.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 1) It all can be reduced to 4K + 4K by asuming all IRQ happen on one CPU.

no it's separate stacks for soft and hard irqs, so it's really 4+4+4


another angle is that while correctness rules, userspace correctness
rules as well. If you can't fork enough threads for what you need the
machine for, why have the machine in the first place?

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

