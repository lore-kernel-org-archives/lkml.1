Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbYF2NRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbYF2NRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 09:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYF2NRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 09:17:31 -0400
Received: from h155.mvista.com ([63.81.120.155]:62544 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754841AbYF2NRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 09:17:30 -0400
Message-ID: <48678B72.4000706@ru.mvista.com>
Date: Sun, 29 Jun 2008 17:17:38 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: avorontsov@ru.mvista.com, Ingo Molnar <mingo@elte.hu>,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with preemptable
 hardirqs
References: <20080623234037.GA6793@polina.dev.rtsoft.ru>	<20080623235141.GB17297@elte.hu>	<20080624000016.GA12547@polina.dev.rtsoft.ru>	<20080625123431.GA25452@polina.dev.rtsoft.ru>	<20080628005436.GA1956@polina.dev.rtsoft.ru>	<20080628101431.0b64d6c2@lxorguk.ukuu.org.uk>	<486615E2.3080802@ru.mvista.com> <20080629134943.19b94bd2@lxorguk.ukuu.org.uk>
In-Reply-To: <20080629134943.19b94bd2@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>   His boot log shows the native mode.

> Then the bridge is misprogrammed

>>   What's IDEIRT, some ISA bridge register? And why should one set 
>>[A]PIC to level mode for legacy mode IDE? :-O

> You need an NDA and then they'll send you the data sheet for the bridges
> and other logic. It's all programmable.

    That could be a very long story... :-|

> "He has an OpenPIC, it's PowerPC SoC, so no ELCR either"

> Really - he's using a designed for PC ISA bridge etc.. he might have all
> sorts of stuff on it.

   Ah, indeed. I meant to say that 8259 and ELCR are bypassed for PCI IRQs (or 
at least Anton says so :-).

> Alan

MBR, Sergei
