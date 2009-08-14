Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZHNKLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZHNKLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZHNKLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:11:14 -0400
Received: from www.lumino.de ([85.159.12.10]:49249 "HELO imap.lumino.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753172AbZHNKLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:11:13 -0400
Message-ID: <4A853840.8060901@lumino.de>
Date: Fri, 14 Aug 2009 12:11:12 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: implementing Futex
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de> <4A8525A1.205@lumino.de> <200908141128.01179.arnd@arndb.de>
In-Reply-To: <200908141128.01179.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> Well, if you want to support SMP, you really need full atomic operations,
> the easiest way for that would be the load-locked / store conditional
> method used on most RISC machines.

I see. But unless Altera provides an enhancement to the NIOS2 design, we
are lost here.

-Michael
