Return-Path: <linux-kernel-owner+w=401wt.eu-S965127AbXAYBvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965127AbXAYBvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 20:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965134AbXAYBvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 20:51:47 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40416
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965127AbXAYBvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 20:51:46 -0500
From: Rob Landley <rob@landley.net>
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [rft] (g)awk substitution (Re: [PATCH] sed s/gawk/awk/scripts/gen_init_ramfs.sh)
Date: Wed, 24 Jan 2007 20:51:32 -0500
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200701151624.18033.rob@landley.net> <200701241230.40996.rob@landley.net> <E1H9pHf-0002Iu-4D@flower>
In-Reply-To: <E1H9pHf-0002Iu-4D@flower>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701242051.34153.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 January 2007 4:03 pm, Oleg Verych wrote:

> Let me propose you to test this as solution, that need no awk, only shell:

Actually awk is one of the standard Single Unix Specification (version 3) 
utilities and the kernel build uses it in a number of places, such as 
arch/alpha/boot/Makefile, drivers/eisa/Makefile, scripts/ver_linux.

Your objection is a bit like saying "and don't use cat".  I'm saying don't 
call cat "gcat" when you just mean plain old cat.

> p.s. who is going to make alternative to GNU make ? ;D

Me.  Seriously.  It's on my todo list, as part of the Firmware Linux project:

http://lwn.net/Articles/215941/

Although as major projects go, it's about fifth down on the list after getting 
toybox up to speed, writing a proper bash replacement shell, getting tcc to 
build an unmodified Linux kernel, convincing the uClibc guys to HAVE ANOTHER 
RELEASE ALREADY (it's been a year and a half, I _sent_ a cake)...

Today, I'm writing a gene2fs that produces streaming output (I.E. it works 
like tar).  It's not done yet...

Rob
-- 
"Perfection is reached, not when there is no longer anything to add, but
when there is no longer anything to take away." - Antoine de Saint-Exupery
