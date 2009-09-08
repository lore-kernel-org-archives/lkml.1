Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbZIHXii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbZIHXii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZIHXih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:38:37 -0400
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:46311 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbZIHXig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:38:36 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net 283C2256D52
Message-ID: <4AA6EAFD.1090707@arcor.de>
Date: Wed, 09 Sep 2009 02:38:37 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Juergen Beisert <jbe@pengutronix.de>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <20090908013800.296a5fb5@infradead.org> <4AA62E4E.4040700@arcor.de> <200909081332.46129.jbe@pengutronix.de> <4AA6D40F.6040600@arcor.de> <alpine.LRH.2.00.0909090120531.25928@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0909090120531.25928@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 02:20 AM, Jiri Kosina wrote:
> On Wed, 9 Sep 2009, Nikos Chantziaras wrote:
>
>>>> Here the result:
>>>>
>>>>        http://foss.math.aegean.gr/~realnc/pics/latop2.png
>>>>
>>>> Again: this is on an Intel Core 2 Duo CPU.
>>>
>>> Just an idea: Maybe some system management code hits you?
>>
>> I'm not sure what is meant with "system management code."
>
> System management interrupt happens when firmware/BIOS/HW-debugger is
> executed in privilege mode so high, that even OS can't do anything about
> that.
>
> It is used in many situations, such as
>
> - memory errors
> - ACPI (mostly fan control)
> - TPM
>
> OS has small to none possibility to influence SMI/SMM. But if this would
> be the cause, you should probably obtain completely different results on
> different hardware configuration (as it is likely to have completely
> different SMM behavior).

Wouldn't that mean that a BFS-patched kernel would suffer from this too?

In any case, of the above, only fan control is active, and I've run with 
it disabled on occasion (hot summer days, I wanted to just keep it max 
with no fan control) with no change.  As far as I can tell, the Asus P5E 
doesn't have a TPM (the "Deluxe" and "VM" models seem to have one.)  As 
for memory errors, I use unbuffered non-ECC RAM which passes a 
memtest86+ cycle cleanly (well, at least the last time I ran it through 
one, a few months ago.)
