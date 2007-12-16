Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbXLPTpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbXLPTpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbXLPTpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:45:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:32517 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbXLPTpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:45:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=FmdxThChJYPH7IaPAjPfTc5tlmnxakhuiiyN7+g7zrfyRMSP0ly/+Z5pwUY6ZRY3BUeX1MWtOUo1NZbaXBJL4UTZFIG3HSvyJW6UmDsNvtyI72t55I3irp/xfxivNspCvjUfVOIY56/qcV8TY92xT9yVtxAAGo6Homt5ocTSc14=
Message-ID: <47658063.5010707@googlemail.com>
Date: Sun, 16 Dec 2007 20:45:39 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Oliver Joa <oliver@j-o-a.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
References: <4765690C.6010605@j-o-a.de> <47657BA8.3020004@googlemail.com> <47657D79.7090100@j-o-a.de>
In-Reply-To: <47657D79.7090100@j-o-a.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Joa wrote:
> Hi,
> 
> Gabriel C wrote:
>> Oliver Joa wrote:
>>> Hi,
>> Hi Oliver ,
>>
>>> how can I tell the kernel not to probe DMA for a specific harddisk (e.g. 
>>> hda). My first Drive (hda) is a Compact-Flash Card which can not do DMA. 
>>> The kernel tries at boot to switch to DMA but fails. If I use ide=nodma, 
>>> the kernel boots about 2 minutes faster, but then I can not switch on 
>>> DMA for the second Drive (hdc) which is a normal Harddisk. Do I have to 
>>> live with this 2 minutes waiting time or is there another solution? I 
>>> did not find any kernel-parameter for this purpose.
>>>
>>> Sorry if I ask here, but I can not find any solution, and I asked 
>>> already in other groups.
>>>
>>> Thank you very much
>> Should work with hda=nodma or ideX=nodma ( where X is your HDD nr , in your case is 0 )
> 
> I tried this already, it does not work.
> 
>> Also have a look at Documentation/ide.txt.
> 
> I read this already. Searching for "nodma" in this document gives only 
> one line:
> 
>   "ide=nodma"            : disable DMA globally for the IDE subsystem.
> 
> If the documentation is correct hda=nodma and ideX=nodma should not 
> work. I use kernel 2.6.23.1 at the moment.

grep nodma Documentation/ide.txt
 "hdx=nodma"            : disallow DMA

ide=foo_option is for the whole ide sub-system where ideX|hdX=foo_option is just for that HDD.

Anyway I've CC'ed linux-ide.

> 
> Thanks
> 
> Olli
> 


Gabriel
