Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbXJFA0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbXJFA0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 20:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXJFA0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 20:26:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33741 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbXJFA0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 20:26:39 -0400
Date: Sat, 6 Oct 2007 02:26:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
In-Reply-To: <Pine.LNX.4.64.0710060222570.21791@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710060225390.21791@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
 <m3r6k9xi2d.fsf@maximus.localdomain> <Pine.LNX.4.64.0710060137520.21791@fbirervta.pbzchgretzou.qr>
 <m3myuxxfub.fsf@maximus.localdomain> <Pine.LNX.4.64.0710060222570.21791@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 6 2007 02:23, Jan Engelhardt wrote:
>>
>>Not convinced WRT ASCII color codes, though. ASCII doesn't contain
>>codes for changing colors. Perhaps some specific "extended ASCII"?
>
>Start up QBasic, issue
>	COLOR 1
>=> blue.
>
>Apply said patch, issue
>	vt.printk_color=0x01
>=> you get what?
>
>So! :)

What we see here might not be "ASCII", but "VGA-specific color values".
It's just that I call it ASCII since it's the mirrored opposite of ANSI.
