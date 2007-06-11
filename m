Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbXFLACJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbXFLACJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXFLAB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:01:57 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:43287 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752313AbXFLAB4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:01:56 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2007 20:01:56 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:In-Reply-To:References:Mime-Version:Content-Type:Message-Id:Cc:Content-Transfer-Encoding:From:Subject:Date:To:X-Mailer;
  b=LgboeKPznHVEp0/h0uw3AEDyzFmHZRoDlVvKAYDrK1tXJBf86nITwwxPv/ItlaiJPcyLEpiXAxvzHbBVJUWT0CRbV4E6YrfmT8uKUVtGXGrGBxq5dk0dQdXwDK6X8QUf6YKPQzrm6Tcu9RwIoygDNLwKD4vxgezafJq9opbjLc8=  ;
X-YMail-OSG: 86gXg0gVM1n81qRrHQplGKd0Rnb2YVAiYfxtUPlxvqkhq5LyF91JIyscsOoUWnbkU36tRXLFug--
In-Reply-To: <20070611101319.GA14284@DervishD>
References: <20070611101319.GA14284@DervishD>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <191337B7-F4CC-4824-B669-48AE194BE141@sbcglobal.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
From: Kevin K <k_krieser@sbcglobal.net>
Subject: Re: ext2 on flash memory
Date: Mon, 11 Jun 2007 18:53:26 -0500
To: DervishD <lkml@dervishd.net>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 11, 2007, at 5:13 AM, DervishD wrote:

>     Hi all :)
>
>     I was wondering: is there any reason not to use ext2 on an USB
> pendrive? Really my question is not only about USB pendrives, but any
> device whose storage is flash based. Let's assume that the device  
> has a
> good quality flash memory with wear leveling and the like...
>
>     Thanks a lot in advance :)
>
>     Raúl Núñez de Arenas Coronado
>


My opinion is that, unless the flash is really cheap, or it is being  
written to excessively, that it probably doesn't matter too much.   
With the growth in size of flash, just how long do you think it will  
continue to be used before you go to something larger?

A 256MB flash of a few years ago has been supplanted in many cases by  
today's 2-4gb memory.

One suggestion with ext2 might be to mount it with the noatime  
option, so it doesn't update the last access time for directories and  
files.  Otherwise, you are doing a write even when you only plan to  
read a file.


