Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbYE2LB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbYE2LB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYE2LBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:01:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56094 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750974AbYE2LBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:01:16 -0400
Date: Thu, 29 May 2008 11:46:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: benh@kernel.crashing.org, Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080529114634.048ea9a0@core>
In-Reply-To: <200805290910.07207.arnd@arndb.de>
References: <1211852026.3286.36.camel@pasglop>
	<alpine.LFD.1.10.0805271451100.2958@woody.linux-foundation.org>
	<1211926779.3286.104.camel@pasglop>
	<200805290910.07207.arnd@arndb.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not exactly a well-established interface. Only five architectures
> define these functions, and there is not a single user in the kernel
> source outside of these architecture's io.h files.

That is because the drivers using them had them removed (eg I²O) - mostly
because "it didn't compile on power pc" 8(


Alan
