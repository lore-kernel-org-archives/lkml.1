Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbXF0KnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbXF0KnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 06:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXF0KnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 06:43:05 -0400
Received: from smtpout.mac.com ([17.250.248.185]:53714 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbXF0KnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 06:43:04 -0400
In-Reply-To: <6278d2220706270249v410d7b8eyfca9873d55075c75@mail.gmail.com>
References: <6278d2220706270247k21ccdd24x41b84c631b05fcc0@mail.gmail.com> <6278d2220706270249v410d7b8eyfca9873d55075c75@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1090CBC0-91B3-49EC-9A69-4864201CA967@mac.com>
Cc: Marc Perkel <mperkel@yahoo.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: NVidia Driver Support - 1680x1050 mode
Date: Wed, 27 Jun 2007 06:42:59 -0400
To: Daniel J Blueman <daniel.blueman@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc, please choose a more appropriate list next time.  LKML is not  
for user questions about "Why doesn't my monitor+GPU work?"

On Jun 27, 2007, at 05:49:20, Daniel J Blueman wrote:
> On 27 Jun, 04:40, Marc Perkel <mperkel@yahoo.com> wrote:
>> Trying to get my Asus M2NPV-VM motherboard and my Samsung  
>> SyncMaster 215tw Digital to work in 1680x1050 mode but 1280x1024  
>> is the most I can get. Chip Set is GeForce 6150.
>>
>> Looking in Xorg.0.log it ssems to think that the panel size is  
>> 1280x1024 in spite of my setting telling it differently.
>>
>> Sorry if this is off topic but I thought that the smart people  
>> would be here. In Windows I just plug it in and it works. So I  
>> figure Linux should work too. :)
>
> Wrong list, but anyway...
>
> If you're using a DVI cable, ensure it is dual-link.

Uhh, no;  1680x1050 does not require a dual-link DVI port/cable.  As  
to a good GPU which "Just Works(TM)" out of the box and still has at  
least passable render performance (although not for some modern  
games),  the R200-series Radeon cards (listed below) work extremely  
well.  They even support a 3d-accelerated merged-framebuffer Xinerama- 
style; you can split a 3d-accelerated window across both monitors.

R200-series cards:
   R200:  Radeon 8500/8500LE/9100, FireGL 8700/8800
   rv250: Radeon 9000/9000Pro
   rv280: Radeon 9200/9250/9200SE

More info here:
   http://dri.freedesktop.org/wiki/ 
ATIRadeon#head-9161ac9470497d94f1a4f79794697347b20d5170

Cheers,
Kyle Moffett
