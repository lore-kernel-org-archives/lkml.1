Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXLLNVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXLLNVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXLLNVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:21:47 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:35060 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXLLNVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:21:46 -0500
Message-ID: <475FE010.30208@keyaccess.nl>
Date: Wed, 12 Dec 2007 14:20:16 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <20071212004316.079e3a05@Varda> <Pine.LNX.4.61.0712120753210.4443@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0712120753210.4443@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 13:59, linux-os (Dick Johnson) wrote:

> On Tue, 11 Dec 2007, [utf-8] Alejandro Riveira Fern?ndez wrote:

>> On my AMD 3800 X2 (2000MHz) ULi M1697 2.6.24-rc5 i get:
>>
>> cycles: out 1844674407370808, in 1844674407369087
>>
>> It is not constant but variations are not significant afaics
>>
> 
> It looks as though this hardware does not have a port 0x80
> and its access is trapped by the hardware with a long time-out!
> This may be the reason when the _p was called "harmful" on this
> platform!
> 
> I'm not sure the "rules" for port access allow for this kind of
> behavior. This design may be defective, needing to be brought
> to the attention of the vendor. A decent vendor would update
> a FPGA and provide code to burn a new BIOS.

I'm afraid it's just the test that is "defective" as 64-bit code. For some 
reason "=A" doesn't mean edx:eax on amd64 even though it's a useful register 
pair to be able to name there as well. Didn't catch that being without amd64 
machines myself.

Oh well. gcc -m32 fixes it...

Rene.
