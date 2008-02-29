Return-Path: <linux-kernel-owner+w=401wt.eu-S933462AbYB2T0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462AbYB2T0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbYB2T0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:26:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43050 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651AbYB2T0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:26:23 -0500
Message-ID: <47C85B46.6040504@zytor.com>
Date: Fri, 29 Feb 2008 11:21:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <Yinghai.Lu@Sun.COM>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 pci: remove checking type for mmconfig probe v2
References: <200802271639.52958.yinghai.lu@sun.com> <200802282356.50496.yinghai.lu@sun.com> <20080229191745.GA19476@elte.hu>
In-Reply-To: <20080229191745.GA19476@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
>> doesn't need to check if it is type1 or type2. we can use raw_pci_ops 
>> dirctly.
>>
>> also make pci_direct_conf1 static again.
>>
>> anyway is there system with type 2 and mmconf support?
> 
> i've picked it up into x86.git#testing so it gets test coverage, but it 
> would be nice to hear what Greg and the other PCI folks think about 
> this.

There *shouldn't* be any system with type 2 and mmconf, since type 1 was 
made mandatory long before mmconf was created.

	-hpa

