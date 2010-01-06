Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215Ab0AFVc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab0AFVc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025Ab0AFVc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:32:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37325 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab0AFVcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:32:23 -0500
Message-ID: <4B45001E.7000404@zytor.com>
Date: Wed, 06 Jan 2010 13:26:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christian Hofstaedtler <ch@zeha.at>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
References: <20100104162114.GA30113@percival.namespace.at> <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain> <4B4225B3.8070705@zytor.com> <20100104174558.158cd512@infradead.org> <20100106143640.GB13984@srcf.ucam.org> <alpine.LFD.2.00.1001061321260.4086@localhost.localdomain> <20100106193608.GA21447@srcf.ucam.org> <alpine.LFD.2.00.1001061504110.4086@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001061504110.4086@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 12:22 PM, Len Brown wrote:
>>
>> It's effectively guaranteed if the system is validated with Windows.
> 
> today's common industry practice != future guarantee
> 
> We can't rely on blind use of _OSI to mean "new enough", since
> it was supported back in W2K era.  That means we have to parse
> the OSI strings.  But what happens when a BIOS writer decides to
> evaluate _OSI("Windows Future") without evaluating any of the
> old strings we know about?  We would disable ACPI reset on such
> a future box?
> 

What about using _OSI() with a *blacklist*, i.e. treat _OSI("Unknown
String") as "new enough", whereas _OSI("Windows 2000") is ignored?

	-hpa

