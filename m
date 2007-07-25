Return-Path: <linux-kernel-owner+w=401wt.eu-S935262AbXGYTSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935262AbXGYTSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759570AbXGYTRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:17:54 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:52664 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759490AbXGYTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:17:53 -0400
Message-ID: <46A7A1D5.7020003@freescale.com>
Date: Wed, 25 Jul 2007 14:17:41 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.7.10) Gecko/20050909 Red Hat/1.7.10-1.1.3.2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <46A79DE0.8060405@ru.mvista.com> <46A79F14.9040409@freescale.com> <46A7A17C.8090505@ru.mvista.com>
In-Reply-To: <46A7A17C.8090505@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
>> It doesn't buy us anything in here, but it's conceivable that someone 
>> may want to write a driver that uses a shift in the I/O accessor 
>> rather than an array of port offsets,
> 
> 
>    It wouldn't be IDE driver then, and neither it would be libata which 
> also does this another way this (despite pata_platform uses shifts too 
> -- not in the accessors, so no speed loss).

The device tree is not just for Linux.

>> equivalent of the cntlzw innstruction, and shift makes it clear that 
>> the stride must be power-of-two).  Plus, using shift is consistent 
>> with what we do on ns16550.
> 
> 
>    Why the heck should we care about the UART code taling about IDE?!

Consistency?

>    So, let me consider your argument purely speculative and invalid. ;-)

Consider it whatever you want. :-)

-Scott
