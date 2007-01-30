Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbXA3XSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbXA3XSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXA3XSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:18:45 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:12332 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXA3XSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:18:44 -0500
Date: Tue, 30 Jan 2007 17:09:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: ACPI C and P states on Conroe
In-reply-to: <fa.kcyyw0/u0jusCdUVaHf0ecFyj0E@ifi.uio.no>
To: Joe Harvell <jharvell@dogpad.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <45BFD025.10902@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.kcyyw0/u0jusCdUVaHf0ecFyj0E@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Harvell wrote:
> I am trying to enable all the power saving features I can on my Conroe 
> E6600.  After much searching on the web, I am a little confused about 
> the Linux kernel support for ACPI on the Conroe.
> 
> Here is my setup:
> Intel Core2 Duo E6600
> Asus P5-B Deluxe board (Intel P965).
> I am running a Gentoo kernel based on 2.6.19.4.
> 
> I have managed to enable EIST using cpufreq with the speedstep-centrino 
> driver.  But my understanding from browsing the ACPI spec is that this 
> is still within C0, i.e. not much power savings.

C-states are something else entirely, frequency scaling and C-states are 
essentially independent. You can be in lower frequency and C1, C2, etc. 
and it will still use less power.

> 
> Here are my questions:
> 
> 1) For P states, which cpufreq driver should I be using?  I've heard 
> speedstep-centrino is deprecated (but only some aspects of it) that are 

Right.

> being moved into acpi-cpufreq.  But I can't get acpi-cpufreq to load in 
> my kernel version.  Also, I would have thought speedstep-ich would be 

Are you sure? Are you getting error messages?

> the driver, just based on the name.  How do I know (other than trying 

No, that's only for some older chipsets.

> all modules to see which one loads) which one I should be using?

That's the easiest way, and that's what Fedora does for example (just 
compile all the drivers into the kernel). acpi-cpufreq should be the one 
for all modern boards, however.

> 2) What kind of support for C1-C3 does the Conroe have?  The ACPI spec 
> says C2 and C3 require chipset support on the motherboard.  Does P965 
> have that.  Does it matter between boards (e.g. P5B)?

The kernel will only use C2 and C3 if the motherboard exports support 
for it through ACPI. Most desktop boards don't, this is normally only 
found on laptops.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

