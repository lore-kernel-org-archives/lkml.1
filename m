Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbXLHDvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbXLHDvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 22:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXLHDvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 22:51:45 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:3465 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXLHDvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 22:51:45 -0500
Date: Fri, 07 Dec 2007 21:50:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: x86_64 dynticks not working   prev: cpuidle,
 dynticks compatible or no?
In-reply-to: <fa.exjBuk8I+Vs1DPTCnfjHA4mJ5iE@ifi.uio.no>
To: Ed Sweetman <safemode2@comcast.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <475A148C.50100@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.neCPfeOoC5rmM5re+ZzLHNAq2IU@ifi.uio.no>
 <fa.exjBuk8I+Vs1DPTCnfjHA4mJ5iE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Sweetman wrote:
> System is idle now, previously it was doing something i couldn't halt at 
> the time.  I'm looking at "Local timer interrupts" in the "Loc:" section 
> of /proc/interrupts.
> Across 1 second while the system is pretty much idle, i still get 300 
> interrupts. My HZ variable is set to 300 in the kernel config, so this 
> is expected but I was under the assumption that dynticks/tickless being 
> compiled in would cause that to be much lower.
> 
> Am I reading the wrong section of /proc/interrupts  to verify if 
> dynticks is working or not? Again, i see no difference in cpu temp at all.

Try running powertop ( http://www.lesswatts.org/projects/powertop/ ) and 
see what it reports.

I don't think dynticks will generally save huge amounts of power on a 
typical desktop machine. The big gains come from being able to stay in 
deep sleep C-states (C2/C3) for longer periods of time, but most desktop 
machines only enable sleep states down to C1.

> 
> In case it helps, this is an athlon64 x2 with apic functioning and both 
> cores active in 64bit mode. dmesg is below.
> not related :
> Some additional notes:  it87 is my lm_sensor, it doesn't work in this 
> kernel, yet it did in 2.6.22.  Perhaps enabling high precision timers 
> changed something in acpi land.
> 
> I enabled tcp dma offloading in this kernel, i get debugging output 
> related to it, error is at the last line.  No corruption or otherwise 
> bad behavior.   Transferring via cifs at 9.7MB/sec "incoming" took about 
> 15% of one cpu...  I never bothered to check if that is the norm but i 
> suspect i'll be removing that feature as it seems to not play nice with 
> the kernel.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

