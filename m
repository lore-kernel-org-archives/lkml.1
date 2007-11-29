Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbXK2WRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbXK2WRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762978AbXK2WQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:16:40 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:59343 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762957AbXK2WQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:16:38 -0500
Message-ID: <474F3A4B.3080304@cfl.rr.com>
Date: Thu, 29 Nov 2007 17:16:43 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com> <20071120220512.46b9e975@the-village.bc.nu> <20071126120649.GC4701@ucw.cz> <474CCA82.7030000@gmail.com>
In-Reply-To: <474CCA82.7030000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2007 22:16:52.0886 (UTC) FILETIME=[8B701360:01C832D5]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15576.001
X-TM-AS-Result: No--4.341400-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Agreed.  Nobody cared on ATA controllers is usually very effective at
> taking the whole machine down.  Is there any reason why we don't turn on
> irqpoll on turned off IRQs automatically?

Why does a single spurious interrupt cause it to be shut down?  I can 
see if the interrupt is stuck on and keeps interrupting constantly, but 
if it's just the occasional spurious interrupt, why not just ignore it 
and move on?

