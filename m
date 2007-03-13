Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbXCMNFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbXCMNFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 09:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXCMNF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 09:05:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33039 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753246AbXCMNF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 09:05:28 -0400
Date: Tue, 13 Mar 2007 14:03:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vladimir Brik <no.hope@gmail.com>, Andi Kleen <ak@muc.de>,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Randy Dunlap <randy.dunlap@oracle.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Ray Lee <ray-lk@madrabbit.org>,
       Colchao <colchaodemola@gmail.com>,
       Mathieu =?UTF-8?B?QsOpcmFyZA==?= <Mathieu.Berard@crans.org>,
       Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: [3/6] 2.6.21-rc3: known regressions
Message-ID: <20070313140323.6ee03eee@lxorguk.ukuu.org.uk>
In-Reply-To: <20070313125006.GT18731@stusta.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	<20070313125006.GT18731@stusta.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject    : libata: PATA UDMA/100 configured as UDMA/33
> References : http://lkml.org/lkml/2007/2/20/294
>              http://www.mail-archive.com/linux-ide@vger.kernel.org/msg04115.html
>              http://bugzilla.kernel.org/show_bug.cgi?id=8133
>              http://bugzilla.kernel.org/show_bug.cgi?id=8164
> Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
>              Plamen Petrov <plamen.petrov@tk.ru.acad.bg>
>              Laurent Riffard <laurent.riffard@free.fr>
> Handled-By : Tejun Heo <htejun@gmail.com>
> Status     : patch available

Some cases should be fixed now but probably not all (eg the Nvidia one)
