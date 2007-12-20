Return-Path: <linux-kernel-owner+w=401wt.eu-S1764252AbXLTOfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764252AbXLTOfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932535AbXLTOTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:19:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763754AbXLTOTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:19:05 -0500
Message-ID: <476A79D4.4090002@redhat.com>
Date: Thu, 20 Dec 2007 09:19:00 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 1/5]PCI: x86 MMCONFIG: introduce PCI_USING_MMCONF]
References: <476A5EAF.6020008@redhat.com>
In-Reply-To: <476A5EAF.6020008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Camuso wrote:

> 
> Greg KH wrote:
>> On Wed, Dec 19, 2007 at 05:17:51PM -0500, tcamuso@redhat.com wrote:
>>>  
>>> +extern struct pci_ops pci_legacy_ops;     /* direct.c */
>>
>> This isn't needed in this patch at all, and might make the compiler
>> confused if you were to build with only this patch present :(
>>
>> thanks,
>>
>> greg k-h
> 
> Yes, of course. I missed that. Thank you.
> 
I take that back.

This struct must be declared extern because it is referenced in
arch/x86/pci/common.c by pcibios_fix_bus_scan_quirk()

