Return-Path: <linux-kernel-owner+w=401wt.eu-S1761007AbYF2OXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007AbYF2OXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 10:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759708AbYF2OXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 10:23:05 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:12125 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758308AbYF2OXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 10:23:04 -0400
Date: Sun, 29 Jun 2008 18:23:00 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with
	preemptable hardirqs
Message-ID: <20080629142300.GA4599@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <20080628005436.GA1956@polina.dev.rtsoft.ru> <20080628101431.0b64d6c2@lxorguk.ukuu.org.uk> <486615E2.3080802@ru.mvista.com> <20080629134943.19b94bd2@lxorguk.ukuu.org.uk> <48678B72.4000706@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <48678B72.4000706@ru.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 05:17:38PM +0400, Sergei Shtylyov wrote:
> Alan Cox wrote:
>
>>>   His boot log shows the native mode.
>
>> Then the bridge is misprogrammed
>
>>>   What's IDEIRT, some ISA bridge register? And why should one set  
>>> [A]PIC to level mode for legacy mode IDE? :-O
>
>> You need an NDA and then they'll send you the data sheet for the bridges
>> and other logic. It's all programmable.
>
>    That could be a very long story... :-|
>
>> "He has an OpenPIC, it's PowerPC SoC, so no ELCR either"
>
>> Really - he's using a designed for PC ISA bridge etc.. he might have all
>> sorts of stuff on it.
>
>   Ah, indeed. I meant to say that 8259 and ELCR are bypassed for PCI IRQs 
> (or at least Anton says so :-).

Yes, we don't use 8259 for the IDE interrupt.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
