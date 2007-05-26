Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbXEZW6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbXEZW6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbXEZW6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:58:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:26429 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbXEZW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=IRLH9nY90T0KfW9Afgm/ecAaHlRy8ElNBy9alwUcYbCuBN7d4EfHiMwmP9O9ZcRgl1QAew93zfvjKHm4Djj30wl4oCMmPqTDtQZHQO92znMtV0kDWhUXZVHZoo+f7NnCH7hPKythUY4MwVBeEsH4HmZeQK05XQIhiQ9DyS8OXsI=
Message-ID: <4658BB6D.5030603@gmail.com>
Date: Sun, 27 May 2007 02:57:49 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rdreier@cisco.com, greg@kroah.com, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: PCIE
References: <46561287.8020103@gmail.com>	<ada1wh560u1.fsf@cisco.com>	<46584C30.4030206@gmail.com> <20070526.154910.78725926.davem@davemloft.net>
In-Reply-To: <20070526.154910.78725926.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Manu Abraham <abraham.manu@gmail.com>
> Date: Sat, 26 May 2007 19:03:12 +0400
> 
>> i presume then i shouldn't be using IRQF_SHARED, if using MSI.
> 
> That's actually a really good question.
> 
> It is likely architecture dependant whether the PCI controller wires
> unique MSI interrupts to shared cpu interrupt lines.
> 
> I can imagine many systems where the cpu simply doesn't have enough
> interrupt pins to uniquely identify every possible MSI interrupt
> source.
> 

Ok, that explains it a bit, but i am pulling out a bit of hair on the
other aspects i wrote in this thread, of course i am a bit new to PCIe
and hence all my questions/doubts. Hope someone can clear them.

Thanks,
Manu

