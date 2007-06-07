Return-Path: <linux-kernel-owner+w=401wt.eu-S966860AbXFGXUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966860AbXFGXUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936922AbXFGXUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:20:23 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45229 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332AbXFGXUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:20:23 -0400
Message-ID: <4668929C.7040209@zytor.com>
Date: Thu, 07 Jun 2007 16:19:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       kbuild-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kbuild-devel] Another version of cleanfile/cleanpatch
References: <20070605073335.GM7266@flower.upol.cz>	<20070605081959.GB21991@uranus.ravnborg.org>	<20070605133834.GO7266@flower.upol.cz>	<20070605141254.GA24722@uranus.ravnborg.org>	<20070605145759.GP7266@flower.upol.cz>	<20070605151101.GQ7266@flower.upol.cz>	<20070606174556.GS7266@flower.upol.cz>	<20070606175026.GA6303@uranus.ravnborg.org>	<20070606191426.GT7266@flower.upol.cz>	<Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr> <20070607230657.GV7266@flower.upol.cz>
In-Reply-To: <20070607230657.GV7266@flower.upol.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> 
> Because of that, i think, following is redundant:
> 
> - to check for binary files

find . -type f | xargs cleanfile

I do this all the time.

> - scan whole file for long lines, with useless bunch of messages about
>   ones. Useless, because script doesn't fix that, it can't do that!

Still useful to let the human know what is going on, and why.

	-hpa


