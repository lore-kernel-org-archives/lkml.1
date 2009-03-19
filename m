Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZCSNJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZCSNJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZCSNJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:09:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33834 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753854AbZCSNJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:09:12 -0400
Date: Thu, 19 Mar 2009 13:10:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Meelis Roos <mroos@linux.ee>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Lava dual parallel PCI card IRQ problem
Message-ID: <20090319131002.4040b4dd@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0903191500520.4721@ondatra.tartu-labor>
References: <20090318143921.22B5B13A4B0@koiott.tartu-labor>
	<Pine.LNX.4.64.0903191500520.4721@ondatra.tartu-labor>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> PCI parallel port detected: 1407:8000, I/O at 0xdff0(0x0), IRQ 11

Well we are half way there - it has detected the port and IRQ properly.

> parport1: PC-style at 0xdff0 [PCSPP,TRISTATE,EPP]
> [...]
> lp0: using parport0 (interrupt-driven).
> lp1: using parport1 (polling).

You may need to stick a few printks in the port registration path to see
why it made that decision.
