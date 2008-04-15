Return-Path: <linux-kernel-owner+w=401wt.eu-S1763300AbYDOBZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763300AbYDOBZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbYDOBZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:25:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393AbYDOBZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:25:18 -0400
Message-ID: <480403DE.4070901@zytor.com>
Date: Mon, 14 Apr 2008 18:24:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Marc Perkel <mperkel@yahoo.com>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
References: <47FFD3F3.50107@redhat.com>	<821384.64293.qm@web52504.mail.re2.yahoo.com>	<20080411213843.GH2160@csclub.uwaterloo.ca>	<4802608A.3040901@zytor.com>	<20080414151222.GF7385@csclub.uwaterloo.ca> <m3prsrj51j.fsf@maximus.localdomain>
In-Reply-To: <m3prsrj51j.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:
> 
>> True, but usually they give you an option to turn it off in the BIOS to
>> make the system actually work with things like NTP.
>>
>> Maybe I should have said "Any system with spread spectrum enabled".
> 
> I haven't investigated those spread spectrums at all but sometimes
> there are options: "center" (the frequency is centered around the
> nominal value, I guess) and "below" (or something like that). If done
> correctly, "center" shouldn't have visible effect on NTP, should it?

It shouldn't really matter, since "below" produces a similar spectrum at 
a slightly lower frequency.

The main issue is how slow the frequency slew really is; typically the 
slew should well average out to zero over the timescale that NTP cares 
about.

> The other important question is "what frequency has spread spectrum
> enabled"? CPU (= TSC), HPET, RAM, something else?

In PCs, the TSC and RAM will be affected; the HPET, PMTMR and PIT are 
fed from the 14.31818 MHz timekeeping crystal which is generally *not* 
spread.

	-hpa
