Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZIRLuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZIRLuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZIRLuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:50:22 -0400
Received: from h155.mvista.com ([63.81.120.155]:32958 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753899AbZIRLuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:50:21 -0400
Message-ID: <4AB37492.90407@ru.mvista.com>
Date: Fri, 18 Sep 2009 15:52:50 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: "Jung-Ik (John) Lee" <jilee@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata:ide: Fix udma timings of pdc202xx_old controllers
References: <8b5805ff0909171602v3dc10db9i5920be3a2abf2e04@mail.gmail.com> 	<20090918002322.54099f94@lxorguk.ukuu.org.uk> <8b5805ff0909171654i515c832bm570db9bd5936b11a@mail.gmail.com>
In-Reply-To: <8b5805ff0909171654i515c832bm570db9bd5936b11a@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jung-Ik (John) Lee wrote:

>>>From: John(Jung-Ik) Lee <jilee@google.com>

>>>Fix udma timings of pdc202xx_old controllers.
>>>MB=1, MC=1 (0x20, 0x01) for all UDMA modes of pdc2026{57}.

    The patch should be broken in two as it's for 2 different subsystems.

>>On what documentation is this based ?

> I have two documents, 20265, and 20267, and both need to set to the
> same single value for all UDMA modes.

> Doc 1:
>   PDC20265 Bus Mastering Ultra DMA PCI –ATA/ATAPI Controller
> Specification Rev 2.0
>   #7.17.2, Ultra DMA Data Transfer Speed list
>     For all Ultra DMA mode, MB, MC = 01h, 01h

> Doc 2:
>   PDC20267 Bus Mastering Ultra DMA PCI –ATA/ATAPI Controller
> Specification Rev 2.0
>   #7.17.2, Ultra DMA Data Transfer Speed list
>     For all Ultra DMA mode, MB, MC = 01h, 01h

> Are there other pdc202xx old controllers that are different?

    There are PDC20262 and PDC20246. We should ask Bart -- he probably has 
the documatation for them...

> -John

>>Alan

WBR, Sergei

