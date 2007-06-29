Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbXF2SLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbXF2SLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932300AbXF2SLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:11:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59060 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760119AbXF2SLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:11:02 -0400
Message-ID: <46854B29.80906@garzik.org>
Date: Fri, 29 Jun 2007 14:10:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Chuck Ebbert <cebbert@redhat.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rodrigo Luiz <troops.of.doom@gmail.com>, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Ben Collins <bcollins@ubuntu.com>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
       Rodney Gordon II <meff@spherevision.org>
Subject: Re: [1/2] 2.6.22-rc6: known regressions v2
References: <46852187.3080504@googlemail.com>	<20070629175920.6af0c62b@the-village.bc.nu>	<468543CE.6080401@redhat.com> <20070629190602.4ef6a0cb@the-village.bc.nu>
In-Reply-To: <20070629190602.4ef6a0cb@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> I'm not even sure this report is IT8212 related rather than just an IRQ
>>> storm
>> Why does the driver report "irq 0"?
>>
>> ata7: PATA max UDMA/133 cmd <blah> ctl <blah> bmdma <blah> irq 0  <====
>>
>> Above that, the ACPI layer says it assigned IRQ 20
> 
> Because the libata core code in 2.6.22rc6 reports all the ports and IRQ
> values wrongly ?

AFAIK that was fixed, for IRQ.  Please point out examples where it 
remains broken...

	Jeff



