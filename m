Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXAaASk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXAaASk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXAaASj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:18:39 -0500
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:30696 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752064AbXAaASj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:18:39 -0500
X-YMail-OSG: EBmj7oEVM1myazo6UK83CteV3oWgZdvU05RpqgzaUXZYfbUE
Message-ID: <45BFE04A.60004@dogpad.net>
Date: Tue, 30 Jan 2007 18:18:18 -0600
From: Joe Harvell <jharvell+lists.linux-kernel@dogpad.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20061230)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: ACPI C and P states on Conroe
References: <fa.kcyyw0/u0jusCdUVaHf0ecFyj0E@ifi.uio.no> <45BFD025.10902@shaw.ca>
In-Reply-To: <45BFD025.10902@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Joe Harvell wrote:
>
>>
>> Here are my questions:
>>
>> 1) For P states, which cpufreq driver should I be using?  I've heard 
>> speedstep-centrino is deprecated (but only some aspects of it) that are 
>
> Right.
>
>> being moved into acpi-cpufreq.  But I can't get acpi-cpufreq to load 
>> in my kernel version.  Also, I would have thought speedstep-ich would be 
>
> Are you sure? Are you getting error messages?
>
>
I forget what the output from modprobe said.  But I had 
cpufreq.debug=7.  Here are the logs:

Jan 29 09:10:38 [kernel] acpi-cpufreq: acpi_cpufreq_init
Jan 29 09:10:38 [kernel] acpi-cpufreq: acpi_cpufreq_early_init
Jan 29 09:10:38 [kernel] cpufreq-core: trying to register driver 
acpi-cpufreq
Jan 29 09:10:38 [kernel] cpufreq-core: adding CPU 0
Jan 29 09:10:38 [kernel] acpi-cpufreq: acpi_cpufreq_cpu_init
Jan 29 09:10:38 [kernel] acpi-cpufreq: Unsupported address space [127, 127]
Jan 29 09:10:38 [kernel] cpufreq-core: initialization failed
Jan 29 09:10:38 [kernel] cpufreq-core: adding CPU 1
Jan 29 09:10:38 [kernel] acpi-cpufreq: acpi_cpufreq_cpu_init
Jan 29 09:10:38 [kernel] acpi-cpufreq: Unsupported address space [127, 127]
Jan 29 09:10:38 [kernel] cpufreq-core: initialization failed
Jan 29 09:10:38 [kernel] cpufreq-core: no CPU initialized for driver 
acpi-cpufreq
Jan 29 09:10:38 [kernel] cpufreq-core: unregistering CPU 0
Jan 29 09:10:38 [kernel] cpufreq-core: unregistering CPU 1

>
>> 2) What kind of support for C1-C3 does the Conroe have?  The ACPI 
>> spec says C2 and C3 require chipset support on the motherboard.  Does 
>> P965 have that.  Does it matter between boards (e.g. P5B)?
>
> The kernel will only use C2 and C3 if the motherboard exports support 
> for it through ACPI. Most desktop boards don't, this is normally only 
> found on laptops.
>
Okay.  I understand the distinction between what the processor supports 
and what the motherboard exports via the ACPI tables.  I do still want 
to know what C states the E6600 supports.  Does anyone know?  Also, I've 
heard the it's possible to modify the DSDT on boards to add interfaces 
to processor features that the board does not provide.  Of course this 
is a dead end if E6600 doesn't support these low power states to begin 
with.  Assuming it does, does anyone know if it's possible to get them 
working on the Asus P5B Deluxe?


