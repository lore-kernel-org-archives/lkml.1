Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYHFUEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYHFUEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbYHFUD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:03:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43568 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756805AbYHFUD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:03:56 -0400
Date: Wed, 6 Aug 2008 20:46:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: petkovbb@gmail.com
Cc: petkovbb@googlemail.com, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
Message-ID: <20080806204636.220ec693@lxorguk.ukuu.org.uk>
In-Reply-To: <20080806194754.GC31312@gollum.tnic>
References: <20080803143837.GA26672@gollum.tnic>
	<20080803162214.394b13a1@lxorguk.ukuu.org.uk>
	<20080803165135.GA31977@gollum.tnic>
	<4898630C.7090403@ru.mvista.com>
	<9ea470500808050732s7be29360ge358790e955be06a@mail.gmail.com>
	<58cb370e0808050741v7ff3f20awb3d91a84486f8547@mail.gmail.com>
	<20080806061023.GA23773@gollum.tnic>
	<48998C58.20703@ru.mvista.com>
	<9ea470500808060703p4a94c868i25106e081aad75c4@mail.gmail.com>
	<4899C9F4.9040002@ru.mvista.com>
	<20080806194754.GC31312@gollum.tnic>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the comment in there saying that in some cases BAR0-3 could contain junk is a
> bogus? In other words, can we assume that one will always read 0x1f0 from BAR0
> and 0x170 from BAR2 in compatibility mode. If so, the check is even simpler:
> 
> 	if (pci_resource_start(p, 0) == 0x1f0)
> 		*primary = 1;
> 	if (pci_resource_start(p, 2) == 0x170)
> 		*secondary = 1;

In theory, but for the sake of about 30 bytes of code in an obscure 'last
resort work everywhere' driver it seemed a bit pointless.

Alan
