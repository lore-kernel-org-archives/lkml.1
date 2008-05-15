Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYEOCCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYEOCCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYEOCCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:02:00 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46440 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYEOCB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:01:59 -0400
Date: Wed, 14 May 2008 20:04:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Problems with mainboard INTEL D201GLY2A,
 pci devices only available with acpi=noirq
In-reply-to: <fa.vWXVKBGhH014XMsboBQBMW6GFwA@ifi.uio.no>
To: Robert Goldner <robert@au-79.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <482B9A13.2020400@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.vWXVKBGhH014XMsboBQBMW6GFwA@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Goldner wrote:
> Hi everyone,
> 
> I use a INTEL D201GLY2A mainboard, and after serveral trys PCI devices 
> were only useable (not visable) with the boot-parameter acpi=noirq (or 
> noacpi). I tryed several kernel-versions (stated with 2.6.22), and no 
> sucess without his parameter.
> Without acpi=noirq all pci devices are deteced well, but if you want to 
> use them, there is no response.

Do you have the latest BIOS on this board? Any nonstandard BIOS 
settings? It looks like the board is not using APIC but the ACPI IRQ 
information is giving out IRQs over 15, which doesn't make any sense. 
Maybe you're running in some kind of broken/untested BIOS configuration.
