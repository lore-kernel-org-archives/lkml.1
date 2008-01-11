Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYAKEy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYAKEy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 23:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbYAKEyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 23:54:16 -0500
Received: from okcforum.org ([69.17.49.173]:49527 "EHLO mail.okcforum.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734AbYAKEyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 23:54:15 -0500
Message-ID: <4786F66D.1060903@cygnusx-1.org>
Date: Thu, 10 Jan 2008 20:54:05 -0800
From: Nathan Grennan <alistair@cygnusx-1.org>
Organization: Cygnus X-1
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
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
  I seem to have been wrong about the kernel update fixing my mtu issue. 
I am not 100% sure, but I think 7200 works if the forcedeth system is 
sending, but not if the r8169 system is sending.

  I tried a mtu of 3000, and basically the same errors, but I did 
noticed something interesting. Note the three different byte sizes.

DMA: Out of SW-IOMMU space for 2410 bytes at device 0000:03:00.0
DMA: Out of SW-IOMMU space for 3014 bytes at device 0000:03:00.0
DMA: Out of SW-IOMMU space for 3014 bytes at device 0000:03:00.0
DMA: Out of SW-IOMMU space for 3022 bytes at device 0000:03:00.0


  On a side note, leaving the mtu at 1500 seems to work without error, 
and I get about the same performance.
