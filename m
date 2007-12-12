Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbXLLKhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbXLLKhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758433AbXLLKhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:37:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:18403 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552AbXLLKhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:37:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=fFbxYqGj6qjvveCxukkg6EhvEF8UDzjoduVidtGS1Qj84tJfeegieuIO78MEe3URSautQ0kUNxu9bsXmo2OpYKpdVv4ZY+5Yh+R6eyuLw+G1sO4fUfOYjKiuQ9D977coXV0cfc9o8eLErOAU+rMlfSanTj0ljH7KgiQEZZsiJsY=
Message-ID: <475FBA09.7060907@gmail.com>
Date: Wed, 12 Dec 2007 13:38:01 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: bbpetkov@yahoo.de, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1: acpi reboots machine... solved
References: <20071209075001.GA4686@gollum.tnic> <200712111300.24841.bjorn.helgaas@hp.com> <20071211205255.GB5013@gollum.tnic> <200712111709.00313.bjorn.helgaas@hp.com> <20071212101123.GA5619@gollum.tnic>
In-Reply-To: <20071212101123.GA5619@gollum.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Tue, Dec 11, 2007 at 05:08:59PM -0700, Bjorn Helgaas wrote:
>   
>> On Tuesday 11 December 2007 01:52:55 pm Borislav Petkov wrote:
>>     
>>> From what i can roughly tell so far it seems like an resource conflict between acpi and
>>> the pnp requested regions in your patch which result in the acpi_thermal code
>>> to read the wrong (0xff) temperature value and halt the machine, but i might be
>>> wrong on the details since acpi is such a big code chunk to swallow.
>>>       
>> I don't see any obvious conflict from the log you posted.  For the sake
>> of comparison, can you post the corresponding dmesg log after you removed
>> the patch?
>>     
>
> The only difference i see is that ACPI finds EC in DSDT in the working kernel
> and in the broken case something silently fails. Please find attached the 2 bootlogs
> and a disassembled DSDT.
>
>   
This seems to be the start of trouble...
    PCI: Cannot allocate resource region 4 of device 0000:00:1f.3

