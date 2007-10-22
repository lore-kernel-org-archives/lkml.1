Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbXJVReS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbXJVReS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXJVReK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:34:10 -0400
Received: from spirit.analogic.com ([204.178.40.4]:3652 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbXJVReI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:34:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 22 Oct 2007 17:34:07.0122 (UTC) FILETIME=[BF5B6F20:01C814D1]
Content-class: urn:content-classes:message
Subject: RE: Question about free/used memory on Linux
Date: Mon, 22 Oct 2007 13:34:05 -0400
Message-ID: <Pine.LNX.4.61.0710221328160.9412@chaos.analogic.com>
In-reply-to: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847C@xmb-sjc-214.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question about free/used memory on Linux
Thread-Index: AcgU0b9l3Nb+vbFYTyyBl8JnoP+5oA==
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com> <471BA1D1.5040905@linux.vnet.ibm.com> <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847C@xmb-sjc-214.amer.cisco.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Ravinandan Arakali \(rarakali\)" <rarakali@cisco.com>
Cc: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Oct 2007, Ravinandan Arakali (rarakali) wrote:

> Hi Vaidy,
> Thanks for clarifying several of my doubts.
>
> To answer your question about my intention, we currently have a
> system with 2 GB RAM and I need to find out the actual used and
> free memory so that we can decide if the same setup(applications,
> tmpfs etc.) can run on another system with lesser memory.
>
> Is it correct to say that the "used" field "free -m" excluding
> buffers/caches would give the correct idea of used memory
> (I mean does it take care of shared memory, shared copies of
> libraries etc.) ? I assume it does not include /dev/shm usage
> since that's also a tmpfs partition ?
>
> If so, then I can add the memory used by tmpfs partitions to
> the above and get the total memory used ?
>
> For eg. if my "free -m" appears as below:
> Linux(debug)# free -m
>             total       used       free     shared    buffers
> cached
> Mem:          2014        984       1030          0         80
> 594
> -/+ buffers/cache:        309       1705
>
> Can I say that 309MB + 350 MB(size of tmpfs partitions including
> /dev/shm)
> is the used memory on my system ?
>
> Thanks,
> Ravi
>
[Snipped...]

Just boot your present system with MEM=nnn on the command-line,
where nnn is the amount of memory you would like to use in the
new system (like this).

title Fedora Core (2.6.16.24)
 	root (hd0,0)
 	kernel /boot/vmlinuz-2.6.16.24 ro root=LABEL=/ mem=768m nmi_watchdog=0 
rhgb reboot=cb
 	initrd /boot/initrd-2.6.16.24.img



Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
