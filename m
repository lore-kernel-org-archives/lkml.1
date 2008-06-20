Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYFTKdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYFTKdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYFTKdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:33:32 -0400
Received: from rayleigh.systella.fr ([213.41.184.253]:43211 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbYFTKdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:33:31 -0400
X-Greylist: delayed 827 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 06:33:31 EDT
Message-ID: <485B8434.4090502@systella.fr>
Date: Fri, 20 Jun 2008 12:19:32 +0200
From: BERTRAND Joel <joel.bertrand@systella.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; fr-FR; rv:1.8.1.13) Gecko/20080313 Iceape/1.1.9 (Debian-1.1.9-5)
MIME-Version: 1.0
To: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: NETDEV WATCHDOG on U60/SMP
References: <485B6218.4090705@systella.fr> <20080620085236.GA2376@bayes.mathematik.tu-chemnitz.de>
In-Reply-To: <20080620085236.GA2376@bayes.mathematik.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [192.168.254.1]); Fri, 20 Jun 2008 12:19:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steffen Klassert a écrit :
> On Fri, Jun 20, 2008 at 09:54:00AM +0200, BERTRAND Jo?l wrote:
>> 	Hello,
>>
>> 	This mail comes from sparclinux mailing list. I repost it on general 
>> linux kernel mailing list because I'm not sure that this bug is sparc 
>> specific. Nevertheless, I can only reproduce it on sparc64/SMP.
>>
>> 	My U60 runs linux debian with official 2.6.25 linux kernel (I'm
>> currently trying 2.6.25.7) and sometimes, when eth2 is stressed, eth2
>> hangs with NETDEV WATCHDOG :
>>
>> NETDEV WATCHDOG: eth2: transmit timed out
>> eth2: transmit timed out, tx_status 00 status 8601.
>>   diagnostics: net 0ccc media 8880 dma 0000003a fifo 0000
>> eth2: Interrupt posted but not delivered -- IRQ blocked by another device?
>>   Flags; bus-master 1, dirty 2283344(0) current 2283344(0)
>>   Transmit list 00000000 vs. fffff800af098200.
>>   0: @fffff800af098200  length 00000042 status 0c01059a
>>   1: @fffff800af098260  length 00000042 status 0c01059a
>>   2: @fffff800af0982c0  length 00000042 status 0c01059a
>>   3: @fffff800af098320  length 00000042 status 0c01059a
>>   4: @fffff800af098380  length 00000042 status 0c01059a
>>   5: @fffff800af0983e0  length 00000042 status 0c01059a
>>   6: @fffff800af098440  length 00000042 status 0c01059a
>>   7: @fffff800af0984a0  length 00000042 status 0c01059a
>>   8: @fffff800af098500  length 8000002a status 0001002a
>>   9: @fffff800af098560  length 8000002a status 0001002a
>>   10: @fffff800af0985c0  length 8000002a status 0001002a
>>   11: @fffff800af098620  length 8000002a status 0001002a
>>   12: @fffff800af098680  length 8000002a status 0001002a
>>   13: @fffff800af0986e0  length 8000002a status 0001002a
>>   14: @fffff800af098740  length 8000002a status 8001002a
>>   15: @fffff800af0987a0  length 8000002a status 8001002a
>> eth2: Resetting the Tx ring pointer.
>> eth2:  setting full-duplex.
> 
> Some people with similar problems reported, that they can workarround
> their problems by increasing the rx/tx ring sizes of the 3c59x driver.
> See http://bugzilla.kernel.org/show_bug.cgi?id=6444 for details.

	Thanks. I'm trying with RX/TX=256/256 and max_interrupt=1024.

	Regards,

	JKB
