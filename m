Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbXDNPmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbXDNPmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 11:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXDNPmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 11:42:06 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:25007 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbXDNPmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 11:42:05 -0400
Date: Sat, 14 Apr 2007 09:39:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Machine Check Exception on Opteron 265
In-reply-to: <fa.bATEBhtZlyN0K1NKutzIYJJSRC0@ifi.uio.no>
To: "Drift@tihlde" <drift@tihlde.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <4620F5B0.6050704@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.bATEBhtZlyN0K1NKutzIYJJSRC0@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Espen Fjellvær Olsen wrote:
> Hi!
> Today our Opteron 265, 2x2, paniced after many months uptime, giving
> only this error message:
> 
> HARDWARE ERROR
> CPU 2: Machine Check Exception:            4 Bank 4: b60a200100000813
> TSC 6bb9fd0142921a ADDR a891e9b8
> This is not a software problem!
> 
> mcelog --ascii gives this on the above error:
> 
> HARDWARE ERROR
> CPU 2 4 northbridge TSC 6bb9fd0142921a
>   Northbridge ECC error
>   ECC syndrome = 14
>        bit32 = err cpu0
>        bit45 = uncorrected ecc error
>        bit57 = processor context corrupt
>        bit61 = error uncorrected
>   bus error 'local node origin, request didn't time out
>       generic read mem transaction
>       memory access, level generic'
> STATUS b60a200100000813 MCGSTATUS 4
> This is not a software problem!
> 
> 
> As far as we know there wasnt any unuasal activity on the server at the
> time.
> We updated glibc yesterday, but that shouldnt really cause such a problem.
> So now we wonder if this might be an MCE bug, or really a HW problem,
> and if it is one of the CPUs, or the RAM thats faulty.
> We are running 2.6.18.

Sounds like some bad RAM..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

