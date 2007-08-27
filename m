Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbXH0JU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbXH0JU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 05:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXH0JUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 05:20:15 -0400
Received: from salsa.ec-nantes.fr ([130.66.33.3]:45138 "EHLO
	salsa.ec-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbXH0JUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 05:20:13 -0400
X-Greylist: delayed 1193 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2007 05:20:12 EDT
Message-ID: <46D29294.4080302@gmail.com>
Date: Mon, 27 Aug 2007 11:00:04 +0200
From: Giggz <giggzounet@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM : On a laptop Aopen 1556 or 1557 my integrated card-reader
 doesn't work.
References: <46C068FB.1040200@gmail.com>	<20070827005710.b77ab643.akpm@linux-foundation.org> <20070827105224.172fc5b0@poseidon.drzeus.cx>
In-Reply-To: <20070827105224.172fc5b0@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-CentraleNantes-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman a écrit :
> On Mon, 27 Aug 2007 00:57:10 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   
>> I don't even know which subsystem is supposed to handle that device. 
>> Perhaps someone can tell us.  It's a Secure Digital card slot?  I
>> think the MMC subsystem can handle some types SD cards, but not all?
>>
>> Perhaps Pierre can clue us in?
>>
>>     
>
> The MMC layer can handle all MMC and SD cards, but it does not support
> all known controllers as most vendors refuse to release any specs.
>
> Unfortunately, that is the case here. Ricoh has several controller
> interfaces, and currently we only support one of them (the public
> standard sdhci interface).
>
> So until Ricoh changes their policy or someone reverse engineers their
> interface, then I'm afraid you're out of luck.
>
> Rgds
> Pierre
>   
Hi,

Thx for your interest for my problem.

I have try the MMC layer and it doesn't work. But lot's of people on the 
web tell me, that their SD or MMC card are handled like USB (like 
storage). And in my case, nothing happens :'(

If I understand, I can just wait an improvement of the MMC layer, isn't it ?

Thx for your great work!
Regards,
Guillaume



