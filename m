Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYIZClT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYIZClT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYIZClJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:41:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57234 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbYIZClH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:41:07 -0400
Message-ID: <48DC4BC0.7090203@garzik.org>
Date: Thu, 25 Sep 2008 22:41:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andres Freund <andres@anarazel.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: bad DMAR interaction with iwlagn and SATA
References: <200809251511.20132.andres@anarazel.de> <48DC44D4.8000103@garzik.org> <200809260419.07713.andres@anarazel.de>
In-Reply-To: <200809260419.07713.andres@anarazel.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Freund wrote:
> Hi Jeff,
> 
> On Friday 26 September 2008, you wrote in "Re: bad DMAR interaction with 
> iwlagn and SATA":
>> Andres Freund wrote:
>>> sleeping I activated DMAR...
>>> ..
>>> Second:
>>> [ 2937.484251] DMAR:[DMA Read] Request device [00:1f.2] fault addr
>>> fffbf000 [ 2937.484255] DMAR:[fault reason 06] PTE Read access is not set
>>> [ 2937.484297] ata1.00: exception Emask 0x60 SAct 0x1 SErr 0x800 action
>>> 0x6 frozen
>>> [ 2937.484303] ata1.00: irq_stat 0x20000000, host bus error
>>> [ 2937.484309] ata1: SError: { HostInt }
>>> [ 2937.484319] ata1.00: cmd 61/08:00:c0:1d:6b/00:00:07:00:00/40 tag 0 ncq
>>> 4096 out
>>> [ 2937.484321]          res 40/00:00:c0:1d:6b/00:00:07:00:00/40 Emask
>>> 0x60 (host bus error)
>> Ouch, a host bus error is serious nastiness...
> I only hit that with DMAR activated (hit it twice, different boots), so it 
> seems to be related to that. Is there anything I can help to debug that?

No idea about DMAR.  On the ATA side, it pretty diagnoses itself as you 
see here.  Unfortunately, ATA controller is behaving exactly as it 
should, when a major system error is thrown its way.

	Jeff



