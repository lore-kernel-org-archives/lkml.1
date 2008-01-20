Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYATNxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYATNxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 08:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYATNxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 08:53:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48961 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753369AbYATNxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:53:25 -0500
Date: Sun, 20 Jan 2008 13:51:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080120135112.7bc317c7@lxorguk.ukuu.org.uk>
In-Reply-To: <47934FF5.4010904@davidnewall.com>
References: <20080119045918.GA12215@basil.nowhere.org>
	<4792B191.2060801@davidnewall.com>
	<20080120031153.GB6275@one.firstfloor.org>
	<4792D221.1010704@davidnewall.com>
	<20080120051822.GB19784@one.firstfloor.org>
	<4792DD22.4070902@davidnewall.com>
	<20080120130633.76c16d67@lxorguk.ukuu.org.uk>
	<47934FF5.4010904@davidnewall.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, I'm whispering:  The cost is that something desirable but
> incomplete would be removed.  While it's there it's a constant source of
> irritation to those in the know.  Once removed it can be forgotten.  So
> the cost is really that iBCS2 compatibility becomes less likely.  What's
> the benefit in removing it?  Up to 20 cycles per exec?  That's nothing.

Well you whispered many years too late. iBCS support vanished in 2.4
because nobody cared, nobody wanted to maintain it and not a single
vendor saw a business demand to justify assigning someone to do any work
with it.

If you want it back then you need to port the 2.4 iBCS emulation layer
code to 2.6 first. Of course you could probably  also do it all in user
space with some LD_PRELOAD work and binfmt_misc. That might be a bit
slower but a lot more portable.

Alan
