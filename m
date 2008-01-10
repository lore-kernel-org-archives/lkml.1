Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYAJVtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYAJVtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYAJVtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:49:14 -0500
Received: from okcforum.org ([69.17.49.173]:51144 "EHLO mail.okcforum.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYAJVtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:49:13 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 16:49:13 EST
Message-ID: <478690A3.10405@cygnusx-1.org>
Date: Thu, 10 Jan 2008 13:39:47 -0800
From: Nathan Grennan <alistair@cygnusx-1.org>
Organization: Cygnus X-1
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: r8169 and out of space
References: <478655B6.6010406@cygnusx-1.org> <200801101920.47041.alistair@devzero.co.uk> <20080110205727.GA8692@electric-eye.fr.zoreil.com>
In-Reply-To: <20080110205727.GA8692@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Alistair John Strachan <alistair@devzero.co.uk> :
> [..]
>   
>> No, we have not diagnosed the cause of the problem, beyond the swiotlb usage. 
>> I'm adding the r8169 maintainer, linux-net and linux-kernel to CC, to pass on 
>> your information, I hope you don't mind.
>>     
>
> swiotlb fragmentation perhaps ?
>
> Switching the driver to be page based on Rx would help then.
>
> [...]
>   
>>>   I have a Abit AB9 Pro motherboard with Intel P965 chipset, 4gb of
>>> memory, and two onboard r8169.
>>>       
>
> Which r8169 model exactly ?
>
>   
Here is some of the output from lspci -vv.

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
        Subsystem: ABIT Computer Corp. Unknown device 240b
05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
        Subsystem: ABIT Computer Corp. Unknown device 240b


I think I fixed the the 5924 vs 7200 issue by upgrading to 
kernel-2.6.23.13-104.fc8.x86_64.
