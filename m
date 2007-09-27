Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbXI0ET3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbXI0ET3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 00:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXI0ETV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 00:19:21 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:13811 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXI0ETT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 00:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=l7X4IbxKk5fMxPrFMcEaVf8gJhebYkuO+id+wrDnUm9PwU8iPb4pLTyNTDMYz6dxXf18865oA1mNCbzmbQUF5mL5EfRvLA6hiNDvPrKi3q8949BCi4CcgdZPicHNerv/8+8z0Zq3AiIDpxg1qFgbKcgxrimjao4hdtdq+Z5ndQ4=
Message-ID: <46FAFF7A.5070208@gmail.com>
Date: Thu, 27 Sep 2007 09:55:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: David Newall <david@davidnewall.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>, rol@witbe.net
Subject: Re: 2.6.23-rc7 - _random_ IRQ23 : nobody cared
References: <20070924083336.7a08fd61@tux.DEF.witbe.net>	<46F7C933.4080003@davidnewall.com> <20070925090057.5778aa2a@tux.DEF.witbe.net>
In-Reply-To: <20070925090057.5778aa2a@tux.DEF.witbe.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> Hi David,
> 
> On Mon, 24 Sep 2007 23:56:59 +0930
> David Newall <david@davidnewall.com> wrote:
> 
>> Paul Rolland "(???????) wrote:
>>> Hell, IRQ 23 is shared between libata and my modem !!!
>>>   
>> Tried using the modem?
> 
> When no problem is reported, both the libata part and the modem are OK.
> When the problem is reported, at that time, only libata is handling IRQ23
> (the modem is a WinModem, and the driver is an out-kernel module), this 
> is still kernel boot time, and the disabling of the IRQ makes my machine
> unable to complete the boot process (too many disk timeout).
> 
> It could be good to be able to delay the disabling of an IRQ something long
> enough to allow all the modules to be loaded...

Can you change driver load order such that the driver for the modem is
loaded first?

-- 
tejun

