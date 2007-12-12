Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXLLNYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXLLNYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXLLNYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:24:40 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:1624 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbXLLNYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:24:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 12 Dec 2007 13:23:10.0860 (UTC) FILETIME=[24316CC0:01C83CC2]
Content-class: urn:content-classes:message
Subject: Re: [RFT] Port 0x80 I/O speed
Date: Wed, 12 Dec 2007 08:23:10 -0500
Message-ID: <Pine.LNX.4.61.0712120822150.4529@chaos.analogic.com>
in-reply-to: <475FE010.30208@keyaccess.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFT] Port 0x80 I/O speed
thread-index: Acg8wiQ9/yMoy3Z0T7KD0aCX3xS/LA==
References: <475F1DC6.5090403@keyaccess.nl> <20071212004316.079e3a05@Varda> <Pine.LNX.4.61.0712120753210.4443@chaos.analogic.com> <475FE010.30208@keyaccess.nl>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Cc: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, <dpreed@reed.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <pavel@ucw.cz>,
       <andi@firstfloor.org>, <rol@as2917.net>,
       "Krzysztof Halasa" <khc@pm.waw.pl>, <david@davidnewall.com>,
       <hpa@zytor.com>, <john@stoffel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 12 Dec 2007, Rene Herman wrote:

> On 12-12-07 13:59, linux-os (Dick Johnson) wrote:
>
>> On Tue, 11 Dec 2007, [utf-8] Alejandro Riveira Fern?ndez wrote:
>
>>> On my AMD 3800 X2 (2000MHz) ULi M1697 2.6.24-rc5 i get:
>>>
>>> cycles: out 1844674407370808, in 1844674407369087
>>>
>>> It is not constant but variations are not significant afaics
>>>
>>
>> It looks as though this hardware does not have a port 0x80
>> and its access is trapped by the hardware with a long time-out!
>> This may be the reason when the _p was called "harmful" on this
>> platform!
>>
>> I'm not sure the "rules" for port access allow for this kind of
>> behavior. This design may be defective, needing to be brought
>> to the attention of the vendor. A decent vendor would update
>> a FPGA and provide code to burn a new BIOS.
>
> I'm afraid it's just the test that is "defective" as 64-bit code. For some
> reason "=A" doesn't mean edx:eax on amd64 even though it's a useful register
> pair to be able to name there as well. Didn't catch that being without amd64
> machines myself.
>
> Oh well. gcc -m32 fixes it...
>
> Rene.
>

Yep. By bad. I actually believed the returned value!


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
