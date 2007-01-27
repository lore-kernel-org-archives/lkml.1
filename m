Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbXA0Q4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbXA0Q4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 11:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbXA0Q4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 11:56:16 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53645 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbXA0Q4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 11:56:15 -0500
Message-ID: <45BB842C.4030303@garzik.org>
Date: Sat, 27 Jan 2007 11:56:12 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ahci: Marvell 6145 SATA support (preliminary)
References: <20070127034023.GA25959@havoc.gtf.org> <20070127134346.71d8ecf4@localhost.localdomain>
In-Reply-To: <20070127134346.71d8ecf4@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> Were it not for the PATA and interrupt storm bits, I would say that
>> Marvell 6145 works with a simple PCI ID addition.
> 
> 
> The 6101 driver should drive the 6145 pata port via the legacy registers

They cannot co-exist, unfortunately.

	Jeff



