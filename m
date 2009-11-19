Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbZKSOPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbZKSOPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZKSOPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:15:44 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:26799 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751652AbZKSOPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:15:43 -0500
Message-ID: <4B05533A.7020508@ru.mvista.com>
Date: Thu, 19 Nov 2009 17:16:26 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
References: <20091117144450.15430.83450.stgit@localhost.localdomain>	<20091118184125.623e063d@lxorguk.ukuu.org.uk>	<200911182007.07405.bzolnier@gmail.com>	<200911182056.16517.bzolnier@gmail.com> <20091119140259.2fee86e2@lxorguk.ukuu.org.uk>
In-Reply-To: <20091119140259.2fee86e2@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>BTW we can immediately reclaim 300 LOC by simply merging drivers back..

> LoC - lines of comments ? (at least half of them).

> Been testing a bit before fixing up the pata_hpt drivers. Resume from S2R
> doesn't work with drivers/ide/hpt366.c. So it may have code for resume
> but it doesn't actually work for all the chips.

> Reason is fairly obvious - the PCI speed detection logic is broken except
> for the case of a PC boot where the ROM BIOS for the HPT3xx is run. That

    Point out the breakage please. The driver has been developed and tested 
on non-x86 machine with 66 MHz PCI.

> doesn't occur on a resume from RAM so a 66MHz clocked motherboard device
> comes back with the speed guessed wrongly.

WBR, Sergei
