Return-Path: <linux-kernel-owner+w=401wt.eu-S1767300AbXDEUax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767300AbXDEUax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767303AbXDEUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:30:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57598 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767299AbXDEUaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:30:13 -0400
Message-ID: <46155C50.8000003@garzik.org>
Date: Thu, 05 Apr 2007 16:30:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jan-Benedict Glaw <jbglaw@lug-owl.de>, akpm@osdl.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@canonical.com
Subject: Re: [PATCH] HPA support: Revised patch
References: <20070405141352.12fddb6e@the-village.bc.nu>	<20070405192421.GB5131@lug-owl.de> <20070405211804.1f64e515@the-village.bc.nu>
In-Reply-To: <20070405211804.1f64e515@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> +static int ata_ignore_hpa = 0;
>>> +module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
>>> +MODULE_PARM_DESC(ignore_hpa, "Ignore HPA (0=off 1=on)");
>>> +
>>>  static int ata_probe_timeout = ATA_TMOUT_INTERNAL / HZ;
>>>  module_param(ata_probe_timeout, int, 0444);
>>>  MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");
>> For ignore_hpa, it would be nice to not go through inverse logic and
>> fix the help text a bit (0=honor HPA, 1=ignore HPA).
> 
> Umm.. how about  "preserve_hpa" ?

I think he meant fix the help text?

Regardless, it should be "ignore_hpa" as you have it now, though I feel 
the help text requires additional human brain parsing, and could be more 
clear.

	Jeff



