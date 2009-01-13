Return-Path: <linux-kernel-owner+w=401wt.eu-S1759648AbZAMSsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbZAMSsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbZAMSsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:48:17 -0500
Received: from proxy2.bredband.net ([195.54.101.72]:55233 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298AbZAMSsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:48:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoXADtwbEnVcsfHPGdsb2JhbAAIiQuKfQEBAQE1AbwEhW8
Message-ID: <496CE1EF.3090005@sundmangroup.com>
Date: Tue, 13 Jan 2009 19:48:15 +0100
From: Matias <linux@sundmangroup.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Bryon Roche <kain@kain.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Intel x86 Dual Core & Linux AMP
References: <496C8A98.90309@sundmangroup.com> <496CDDA2.8080206@zytor.com>
In-Reply-To: <496CDDA2.8080206@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, thanks for your answers!
I have been working with PowerPC processors in the past and looking at 
Freescale's 8641D it is possible to boot two different kernels on it's 
both cores.

Cheers // Matias





H. Peter Anvin skrev:
> Matias wrote:
>   
>> Is there a way to boot a normal standard home x86 dual core PC with two
>> different Linux Kernels without a hypervisor?
>> The idea is of course to give the Kernels their own address space and
>> their own rootfile systems, the devices would be unique for each kernel
>> etc.
>>
>> Can this be done with a standard BIOS and GRUB/LILO?
>>     
>
> No.  There are way too many shared resources, such as address space and
> interrupt system.  You need a central resource to arbitrate those
> resources, i.e. a hypervisor.
>
> 	-hpa
>
>   
