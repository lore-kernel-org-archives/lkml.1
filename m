Return-Path: <linux-kernel-owner+w=401wt.eu-S937124AbXGMTiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937124AbXGMTiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbXGMTiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:38:08 -0400
Received: from h155.mvista.com ([63.81.120.155]:46184 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760427AbXGMTiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:38:07 -0400
Message-ID: <4697D518.7010108@ru.mvista.com>
Date: Fri, 13 Jul 2007 23:40:08 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
References: <20070221011922.GA1777@freefall.freebsd.org>	<200702210342.20775.bzolnier@gmail.com>	<466EEFD6.9030001@ru.mvista.com>	<200706160123.55636.bzolnier@gmail.com>	<4693D9B6.4090408@ru.mvista.com> <20070713161612.2f2ebb0b@the-village.bc.nu> <46979652.6040201@rtr.ca> <4697987E.3040406@ru.mvista.com> <4697D425.7000300@rtr.ca>
In-Reply-To: <4697D425.7000300@rtr.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:

>>> I've lost the original question from this thread, but the idea of the 

>>    The original question concerned specifically the DMA command 
>> timeout which is twice more than the usual one, WAIT_CMD (10 seconds).

>>> longish
>>> timeouts was that drive *may* be spun down ("standby"), and thus have 
>>> to spin
>>> up again to complete media commands.  Back then, drives were much 
>>> slower at
>>> spinning up than nowadays, and the ATA spec says to allow up to 30 
>>> seconds.

>>    Well, that doesn't explain the DMA case.

> When a drive is in standby, we don't send it anything special to wake up.
> So even DMA commands have to have a long enough timeout to allow
> for spinning up.

    Yes, but why *twice* as long as the others?

> Cheers

MBR, Sergei
