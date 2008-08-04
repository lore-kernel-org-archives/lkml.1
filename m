Return-Path: <linux-kernel-owner+w=401wt.eu-S1764955AbYHDV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764955AbYHDV5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762564AbYHDVzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:55:54 -0400
Received: from h155.mvista.com ([63.81.120.155]:2955 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762454AbYHDVzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:55:53 -0400
Message-ID: <48977AE1.1070402@ru.mvista.com>
Date: Tue, 05 Aug 2008 01:55:45 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no>	<fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no>	<fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no>	<48976168.3020804@shaw.ca> <20080804205508.20a3f917@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804205508.20a3f917@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:
>> I was looking into the 32-bit PIO issue a bit yesterday. It looks like 
>> some of the VLB libata drivers are doing this internally already, so it 
>> shouldn't be hard to do this in the core. Only question is how we know 
>> generically if the controller can do it or not? It looks like in old
>>     
>
> You don't. Basically it is controller dependant. Pretty much all the
> newer controllers support the 32bit PIO data cycles. Most PCI controllers
> it makes no speed difference but host bus controllers (especially
> PIIX/ICH) really benefit.
>   

    In what way if there's no speed gain?

>> supported. I couldn't track down where that bit was actually defined in 
>> the first place, all the way back to ATA-1 it seems to be indicated as 
>> reserved. Actually, I'm not sure why the drive cares in the first place, 
>> it would seem like a pure host controller issue..
>>     
>
> It goes back before IDE into the depths of the original compaq spec. When
> you have a device wired basically directly to the ISA bus (original IDE)
>   

   ISA has only 8/16-bit data bus, so it could not have mattered 
there... and I don't think that there ever was a direct connection 
between the IDE and host bus other than ISA... except maybe EISA.

MBR, Sergei


