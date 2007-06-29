Return-Path: <linux-kernel-owner+w=401wt.eu-S933441AbXF2RkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441AbXF2RkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 13:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbXF2RkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 13:40:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbXF2RkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 13:40:03 -0400
Message-ID: <468543CE.6080401@redhat.com>
Date: Fri, 29 Jun 2007 13:39:26 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rodrigo Luiz <troops.of.doom@gmail.com>, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Ben Collins <bcollins@ubuntu.com>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, Rodney Gordon II <meff@spherevision.org>
Subject: Re: [1/2] 2.6.22-rc6: known regressions v2
References: <46852187.3080504@googlemail.com> <20070629175920.6af0c62b@the-village.bc.nu>
In-Reply-To: <20070629175920.6af0c62b@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2007 12:59 PM, Alan Cox wrote:
>> SATA/PATA
>>
>> Subject    : libata IT821X driver still fails! Hard-freezes system
>> References : http://lkml.org/lkml/2007/6/14/82
>> Submitter  : Rodney Gordon II <meff@spherevision.org>
>> Status     : unknown
> 
> Not a regression as it seems this user's box has always been broken. I've
> been running heavy testing with 2.6.22rc6 and IT8212 and its working
> reliably for the "dumb" mode in question.
> 
> The hardware mode needs a fix Tejun has queued somewhere (probably in
> Jeff's vast backlog) and then works too.
> 
> I'm not even sure this report is IT8212 related rather than just an IRQ
> storm

Why does the driver report "irq 0"?

ata7: PATA max UDMA/133 cmd <blah> ctl <blah> bmdma <blah> irq 0  <====

Above that, the ACPI layer says it assigned IRQ 20

