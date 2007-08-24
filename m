Return-Path: <linux-kernel-owner+w=401wt.eu-S1765241AbXHXTbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765241AbXHXTbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760691AbXHXTbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:31:31 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:58681 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760209AbXHXTba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:31:30 -0400
Date: Fri, 24 Aug 2007 15:31:21 -0400
To: <jirislaby@gmail.com>, <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] /drivers/char sx.c ioremap -> pci_ioremap api
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070824193127.7E067C3825@mailserver10.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 15:15:30 -0400 Alan Cox 
<alan@lxorguk.ukuu.org.uk> wrote:
>ase, 0x80);
>> 
>> remove also the hwbase var.
>> 
>> > +	rebase = pci_iomap(pdev, 0, 0x80);
>> >   	t = readl(rebase + CNTRL_REG_OFFSET);
>
>Switch to ioread* if you are using the iomap interface. Its not a 
>trivial
>conversion and its slower and bulkier - the original ioremap was 
>much
>better
>
>NAK this change therefore

Jiri had requested this in relation to previous patch on unchecked 
ioremap return codes, but if the original ioremap is better NAK is 
fine
here and I won't resubmit w/ the hwbase var pulled out or the readl 
-> ioread32 switchover.

---------------------------------------
Scott Thompson / postfail@hushmail.com
---------------------------------------

