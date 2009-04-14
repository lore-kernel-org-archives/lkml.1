Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZDNPh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZDNPh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZDNPhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:37:48 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:57432 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZDNPhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:37:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QUyBK4FsdqCu/m3A0yBk3VPzM7ULBk/kpPIY4yOfOLAepIbDPyCqhw7rGl5jFG5LXR
         4EUUoEbALaieOaziXaVRlcL+EUoTfwu31M3UZHG0aCx4Dpw6xTZuHJH+oi8tjf2CZdxZ
         QSQORFZ9vy7dqcpEschPzsHR7WFNjGjY0EzNs=
Message-ID: <49E4ADC1.7010503@tuffmail.co.uk>
Date: Tue, 14 Apr 2009 16:37:37 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [BISECTED] EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk>	<49E44415.1040500@tuffmail.co.uk>	<49E456B5.6030006@tuffmail.co.uk>	<200904140859.02188.bjorn.helgaas@hp.com> <20090414081728.10de978a@infradead.org>
In-Reply-To: <20090414081728.10de978a@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 14 Apr 2009 08:59:01 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
>   
>> I can't help with the real problem of why the asynchronous battery
>> init causes the hang.
>>     
>
> that got fixed already for the module case.
>   

Are you not thinking of the BUG due to calling __init functions from async?

I have a distinct _hang_ which occurs in v2.6.30-rc1-205-g08f4416.  Do
you have a fix for that I can try?

Thanks
Alan

