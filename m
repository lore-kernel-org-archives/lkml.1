Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbXLPTxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbXLPTxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbXLPTx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:53:28 -0500
Received: from mail.gatrixx.com ([217.111.11.44]:49393 "EHLO mail.gatrixx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbXLPTx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:53:28 -0500
Message-ID: <47658235.7050409@j-o-a.de>
Date: Sun, 16 Dec 2007 20:53:25 +0100
From: Oliver Joa <oliver@j-o-a.de>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
References: <4765690C.6010605@j-o-a.de> <47657BA8.3020004@googlemail.com> <47657D79.7090100@j-o-a.de> <47658063.5010707@googlemail.com>
In-Reply-To: <47658063.5010707@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Gabriel C wrote:

[...]

>>> Also have a look at Documentation/ide.txt.
>> I read this already. Searching for "nodma" in this document gives only 
>> one line:
>>
>>   "ide=nodma"            : disable DMA globally for the IDE subsystem.
>>
>> If the documentation is correct hda=nodma and ideX=nodma should not 
>> work. I use kernel 2.6.23.1 at the moment.
> 
> grep nodma Documentation/ide.txt
>  "hdx=nodma"            : disallow DMA
> 
> ide=foo_option is for the whole ide sub-system where ideX|hdX=foo_option is just for that HDD.


/usr/src/linux-2.6.23.1$ grep nodma Documentation/ide.txt
  "ide=nodma"            : disable DMA globally for the IDE subsystem.

/usr/src/linux-2.6.21.5$ grep nodma Documentation/ide.txt
  "ide=nodma"            : disable DMA globally for the IDE subsystem.

/usr/src/linux-2.6.12# grep nodma Documentation/ide.txt
  "ide=nodma"            : disable DMA globally for the IDE subsystem.

Sorry, but I can not find this option, and it does not work. Which 
kernel do you use?

Thanks

Olli
