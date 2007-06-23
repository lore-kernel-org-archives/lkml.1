Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbXFWEVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbXFWEVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 00:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbXFWEVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 00:21:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35536 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbXFWEVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 00:21:11 -0400
Message-ID: <467C9F8D.8020000@garzik.org>
Date: Sat, 23 Jun 2007 00:20:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <dwmw2@infradead.org>,
       Adrian Bunk <bunk@stusta.de>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] schedule BLK_DEV_IDE_SATA for removal
References: <20070621235211.GH23017@stusta.de>	<1182483586.10524.33.camel@shinybook.infradead.org>	<20070622101019.0f3b0d3d@the-village.bc.nu> <18044.39404.380472.887065@cargo.ozlabs.ibm.com>
In-Reply-To: <18044.39404.380472.887065@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Alan Cox writes:
> 
>> On Fri, 22 Jun 2007 11:39:45 +0800
>> David Woodhouse <dwmw2@infradead.org> wrote:
>>
>>> On Fri, 2007-06-22 at 01:52 +0200, Adrian Bunk wrote:
>>>> Users should use the libata based drivers for SATA drives.
>>> NAK. Not all IDE drivers are converted yet. Not even all the relatively
>>> common ones.
>> All the common SATA ones are. Just the PowerPC people are falling behind.
>> Really we should obsolete powerpc instead ;)
> 
> What SATA drive uses a non-libata driver on PowerPC?  In fact the
> sata_svw driver used for SATA drives on G5s was one of the early
> libata drivers.  Or are you talking about PATA?

This entire thread is confused :)

Going back to $subject, it is relevant only to the scant few old-IDE 
drivers that do indeed successfully probe and talk to SATA drives, from 
SATA controllers.

The vast majority have always used libata for SATA, but another option 
did indeed exist before libata appeared, for a few controllers.

Alan was just having a bit of fun at dwmw2's expense, since we do indeed 
want to see libata drivers for PowerPC PATA as well :)

	Jeff


