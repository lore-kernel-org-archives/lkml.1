Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbXGISm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbXGISm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759048AbXGISmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:42:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:12166 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954AbXGISmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:42:18 -0400
Date: Mon, 9 Jul 2007 20:42:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oleg Verych <for.gmane@flower.upol.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: drop it ?(Re: [PATCH] fixup binutils printing from scripts/ver_linux)
In-Reply-To: <slrnf94aoa.l6.for.gmane@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0707092041420.2887@fbirervta.pbzchgretzou.qr>
References: <200707090147.58611.jesper.juhl@gmail.com>
 <20070709020606.GA5761@martell.zuzino.mipt.ru> <46919FD1.2060203@googlemail.com>
 <Pine.LNX.4.64.0707091241280.32335@fbirervta.pbzchgretzou.qr>
 <slrnf94817.l6.for.gmane@flower.upol.cz> <slrnf94aoa.l6.for.gmane@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 9 2007 12:20, Oleg Verych wrote:
>
>> Dumb, but better solution: drop that crap, called ver_linux.
>> Know you have many distros, so be happy with any one, and forget about
>> black old days of finding toolchain, that can actually build the kernel.
>
>#v+
>echo 'If some fields are empty or look unusual you may have an old version.'
>echo 'Compare to the current minimal requirements in Documentation/Changes.'
>echo ' '
>#v-
>
>The comment above is yet another cause to remind you to check `reportbug`
>tool and how it organizes collecting of information for particular bug
>report and package.

We could just do $(rpm -qf $(which ld))  :^)


	Jan
-- 
