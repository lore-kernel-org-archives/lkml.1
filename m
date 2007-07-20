Return-Path: <linux-kernel-owner+w=401wt.eu-S939917AbXGTRmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939917AbXGTRmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763821AbXGTRlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:41:47 -0400
Received: from h155.mvista.com ([63.81.120.155]:48581 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762989AbXGTRlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:41:45 -0400
Message-ID: <46A0F453.60005@ru.mvista.com>
Date: Fri, 20 Jul 2007 21:43:47 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
References: <20070720164043.523003359@mail.of.borg> <20070720164324.097994947@mail.of.borg> <20070720173132.GB19424@linux-mips.org> <20070720173359.GA22423@infradead.org>
In-Reply-To: <20070720173359.GA22423@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph:

>>>+#include <asm/irq.h>

>>These days that should probably be <linux/irq.h>.

> Not at all, linux/irq.h is something entirely different.

    Actually, <linux/interrupt.h>

WBR, Sergei
