Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbXLPUbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbXLPUbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 15:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbXLPUbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 15:31:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:14671 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXLPUbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 15:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=vEJ6DGyfLxXj3GeBAH9wDCUCE8VTGDt9HGqs0/nYWAQIs/aidsp6YggcW3VtEmqBgaI8R0nZs483Tf5XusEAgEphIQCGI5bJtmpA4Sgdn8Gvt3JzStWFVbT/exfgdP38SsHxD+4ZJWBBuOPg9jQD2nQZ+O2YjgGW1uYdwxJ6Cnc=
Message-ID: <47658B15.5090600@googlemail.com>
Date: Sun, 16 Dec 2007 21:31:17 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Oliver Joa <oliver@j-o-a.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
References: <4765690C.6010605@j-o-a.de> <47657BA8.3020004@googlemail.com> <47657D79.7090100@j-o-a.de> <47658063.5010707@googlemail.com> <47658235.7050409@j-o-a.de>
In-Reply-To: <47658235.7050409@j-o-a.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Joa wrote:
> Hi,
> 
> Gabriel C wrote:
> 
> [...]
> 
>>>> Also have a look at Documentation/ide.txt.
>>> I read this already. Searching for "nodma" in this document gives only 
>>> one line:
>>>
>>>   "ide=nodma"            : disable DMA globally for the IDE subsystem.
>>>
>>> If the documentation is correct hda=nodma and ideX=nodma should not 
>>> work. I use kernel 2.6.23.1 at the moment.
>> grep nodma Documentation/ide.txt
>>  "hdx=nodma"            : disallow DMA
>>
>> ide=foo_option is for the whole ide sub-system where ideX|hdX=foo_option is just for that HDD.
> 
> 
> /usr/src/linux-2.6.23.1$ grep nodma Documentation/ide.txt
>   "ide=nodma"            : disable DMA globally for the IDE subsystem.
> 
> /usr/src/linux-2.6.21.5$ grep nodma Documentation/ide.txt
>   "ide=nodma"            : disable DMA globally for the IDE subsystem.
> 
> /usr/src/linux-2.6.12# grep nodma Documentation/ide.txt
>   "ide=nodma"            : disable DMA globally for the IDE subsystem.
> 
> Sorry, but I can not find this option, and it does not work. Which 
> kernel do you use?

This is my devel box , running 2.6.24-rc5-git

> 
> Thanks
> 
> Olli
> 

Gabriel
