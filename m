Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXFUS0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXFUS0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXFUS0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:26:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:3550 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXFUS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:26:15 -0400
Date: Thu, 21 Jun 2007 20:26:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jan Kandziora <jjj@gmx.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Limiting load of certain processes
In-Reply-To: <200706211950.40825.jjj@gmx.de>
Message-ID: <Pine.LNX.4.64.0706212020520.26568@fbirervta.pbzchgretzou.qr>
References: <200706211950.40825.jjj@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 21 2007 19:50, Jan Kandziora wrote:
>
>Dear all,
>
>I like to use an old DOS/Clipper application through DOSEMU on a Linux
>application server in a hotel. It works, but (as usual with DOS), it causes
>a processor load of 100% in certain situations, while just waiting for user
>interaction.

That's how it is. When DOS was written, cpu relaxing like the HLT instruction
was not known yet (or was it?), so everything was (and still is) a busy loop.

(Yes, including today's typical x86 BIOSes. Aw crap!)

Of course there may be hacks that try to figure out if a DOS window is idle,
waiting for user input. (Seems like a new invention in Windows 2000 and up).
Since dosemu and all the emulators are not running a genuine Microsoft DOS /
have source, it should be easy game for them to wait non-busily. Or maybe
busy-waiting is _part_ of the emulation; maybe some DOS driver(s) require it.


	Jan
-- 
