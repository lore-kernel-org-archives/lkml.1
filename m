Return-Path: <linux-kernel-owner+w=401wt.eu-S933828AbXIUW7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828AbXIUW7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933769AbXIUW5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:57:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58883 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933717AbXIUW5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:57:48 -0400
Message-ID: <46F44C66.6070609@garzik.org>
Date: Fri, 21 Sep 2007 18:57:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Krzysztof Oledzki <olel@ans.pl>, Valdis.Kletnieks@vt.edu,
       David Miller <davem@davemloft.net>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
References: <200709211201.24475.vda.linux@googlemail.com> <200709212018.06553.vda.linux@googlemail.com> <Pine.LNX.4.64.0709212130490.11228@bizon.gios.gov.pl> <200709212343.41160.vda.linux@googlemail.com>
In-Reply-To: <200709212343.41160.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Friday 21 September 2007 20:33, Krzysztof Oledzki wrote:
>> On Fri, 21 Sep 2007, Denys Vlasenko wrote:
>>
>>> On Friday 21 September 2007 19:36, Valdis.Kletnieks@vt.edu wrote:
>>>> On Fri, 21 Sep 2007 19:05:23 BST, Denys Vlasenko said:
>>>>
>>>>> I plan to use gzip compression on following drivers' firmware,
>>>>> if patches will be accepted:
>>>>>
>>>>>    text    data     bss     dec     hex filename
>>>>>   17653  109968     240  127861   1f375 drivers/net/acenic.o
>>>>>    6628  120448       4  127080   1f068 drivers/net/dgrs.o
>>>>>          ^^^^^^
>>>> Should this be redone to use the existing firmware loading framework to
>>>> load the firmware instead?
>>> Not in every case.
>>>
>>> For example, bnx2 maintainer says that driver and
>>> firmware are closely tied for his driver. IOW: you upgrade kernel
>>> and your NIC is not working anymore.
>> Firmware may come with a kernel. We have a "install modules", we can also 
>> add "install firmware".
> 
> Install where? I boot my machine over NFS, and it has no hard drive.

Special cases already fail when using distro-linked targets like "make 
install."

	Jeff



