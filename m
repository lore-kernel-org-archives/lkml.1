Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbXJGQiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbXJGQiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXJGQhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:37:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46853 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbXJGQhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:37:54 -0400
Date: Sun, 7 Oct 2007 18:37:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
In-Reply-To: <20071007111035.GO22435@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0710071823381.16301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
 <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu>
 <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu>
 <20071007111035.GO22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7 2007 13:10, Oleg Verych wrote:

>This `scrollback' is usual late boot / console one. If fact useful,
>until first tty switch or if `screen` cannot be used. But for some
>reason if scrolling region (DECSTBM) is less than whole screen, nothing
>works.

Actually, scrolling begins to work once userspace starts, and the
scrollback buffer (given enough size) still contains the first screenful
when Linux started, which may include the bootloader (if the loader did not
zero the screen before handing control over).

