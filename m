Return-Path: <linux-kernel-owner+w=401wt.eu-S933266AbZHVKyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbZHVKyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 06:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbZHVKyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 06:54:19 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41305 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbZHVKyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 06:54:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A8FCE50.9070801@s5r6.in-berlin.de>
Date: Sat, 22 Aug 2009 12:54:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Gene Heskett <gene.heskett@verizon.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression: Linux 2.6.31-rc7 lost sensors on asus mobo
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain> <200908212309.31505.gene.heskett@verizon.net> <4A8F8C49.2030406@gmail.com>
In-Reply-To: <4A8F8C49.2030406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> On 08/21/2009 09:09 PM, Gene Heskett wrote:
>>  From messages when I attempt to access the it87:
>> Aug 21 22:59:37 coyote kernel: [  572.507928] it87: Found IT8716F chip at 0x290, revision 1
>> Aug 21 22:59:37 coyote kernel: [  572.507937] it87: in3 is VCC (+5V)
>> Aug 21 22:59:37 coyote kernel: [  572.507939] it87: in7 is VCCH (+5V Stand-By)
>> Aug 21 22:59:37 coyote kernel: [  572.508232] ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__ [0x295-0x296]
>> Aug 21 22:59:37 coyote kernel: [  572.508234] ACPI: Device needs an ACPI driver
...
> The ACPI AML on your machine indicates that the BIOS may attempt to 
> access the it87 hardware, and the kernel now by default blocks it87 from 
> requesting those ports as it may conflict with what the BIOS is trying 
> to do. On some machines, the ACPI BIOS accesses hardware monitoring 
> chips itself to manage ACPI thermal zones, etc. and the conflicting 
> access can cause incorrect temperature readings and other bad behavior.
> 
> You can try acpi_enforce_resources=lax on the kernel command line to 
> restore the previous behavior. Or for some Asus boards, you can try the 
> asus_atk0110 ACPI driver instead of it87.

PS:  There have been previous reports, e.g. those logged as 
http://bugzilla.kernel.org/show_bug.cgi?id=13967
-- 
Stefan Richter
-=====-==--= =--- =-==-
http://arcgraph.de/sr/
