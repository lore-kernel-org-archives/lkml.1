Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbXLPTd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbXLPTd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbXLPTdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:33:18 -0500
Received: from mail.gatrixx.com ([217.111.11.44]:41607 "EHLO mail.gatrixx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbXLPTdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:33:17 -0500
Message-ID: <47657D79.7090100@j-o-a.de>
Date: Sun, 16 Dec 2007 20:33:13 +0100
From: Oliver Joa <oliver@j-o-a.de>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
References: <4765690C.6010605@j-o-a.de> <47657BA8.3020004@googlemail.com>
In-Reply-To: <47657BA8.3020004@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Gabriel C wrote:
> Oliver Joa wrote:
>> Hi,
> 
> Hi Oliver ,
> 
>> how can I tell the kernel not to probe DMA for a specific harddisk (e.g. 
>> hda). My first Drive (hda) is a Compact-Flash Card which can not do DMA. 
>> The kernel tries at boot to switch to DMA but fails. If I use ide=nodma, 
>> the kernel boots about 2 minutes faster, but then I can not switch on 
>> DMA for the second Drive (hdc) which is a normal Harddisk. Do I have to 
>> live with this 2 minutes waiting time or is there another solution? I 
>> did not find any kernel-parameter for this purpose.
>>
>> Sorry if I ask here, but I can not find any solution, and I asked 
>> already in other groups.
>>
>> Thank you very much
> 
> Should work with hda=nodma or ideX=nodma ( where X is your HDD nr , in your case is 0 )

I tried this already, it does not work.

> Also have a look at Documentation/ide.txt.

I read this already. Searching for "nodma" in this document gives only 
one line:

  "ide=nodma"            : disable DMA globally for the IDE subsystem.

If the documentation is correct hda=nodma and ideX=nodma should not 
work. I use kernel 2.6.23.1 at the moment.

Thanks

Olli
