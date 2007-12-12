Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbXLLSpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbXLLSpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbXLLSpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:45:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbXLLSpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:45:09 -0500
Message-ID: <47602BF2.9030602@zytor.com>
Date: Wed, 12 Dec 2007 10:44:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <475FA060.6070004@gmail.com> <4af2d03a0712120325n50d057baq7ec440c5e57fda39@mail.gmail.com>
In-Reply-To: <4af2d03a0712120325n50d057baq7ec440c5e57fda39@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On Dec 12, 2007 9:48 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 12/12/2007 12:31 AM, Rene Herman wrote:
>>> Good day.
>>>
>>> Would some people on x86 (both 32 and 64) be kind enough to compile and
>>> run the attached program? This is about testing how long I/O port access
> 
> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz 
> cycles: out 3217, in 1898

1.6 µs, on the high end....

> model name      : Dual Core AMD Opteron(tm) Processor 275
> cycles: out 5508, in 5524

Definitely an outlier; 2.5 µs here.

	-hpa
