Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZCIRER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZCIRER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZCIREB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:04:01 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:44144 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZCIREA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:04:00 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Linux* Processor Microcode Data File
Date: Mon, 09 Mar 2009 13:03:31 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.28.7; KDE/4.2.0; i686; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, tigran@aivazian.fsnet.co.uk,
       Andreas Herrmann <andreas.herrmann3@amd.com>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
 <200903091158.22918.gene.heskett@verizon.net>
 <20090309162416.GC24213@silver.sucs.org>
In-reply-to: <20090309162416.GC24213@silver.sucs.org>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903091303.32022.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 March 2009, Sitsofe Wheeler wrote:
>At the risk of being wrong twice in a row...
>
>On Mon, Mar 09, 2009 at 11:58:22AM -0400, Gene Heskett wrote:
>> I'll have to admit it was with some trepidation that I might brick my
>> processor, which is a quad core AMD 9550, stepping 03 running at 2.2 ghz,
>> but
>
>Microcode patching in this particular fashion (i.e. _not_ updating the
>BIOS but "on the fly") is volatile (so it has to be redone at every
>boot) which should mean it is very hard to brick a machine this way as
>rebooting will undo everything. Of course someone is going to tell me
>how they managed to kill a machine stone dead due to some sequence of
>events I hadn't thought of and I disclaim any responsiblity if someone
>tries to update their microcode and harms their machine in any fashion -
>you update at your own risk :).
>
>> the directions didn't note until the end, that it would take a 2.6.29
>> series kernel to do it and I was running 2.6.28.7.  But when I got to the
>> modprobe -r microcode, modprobe microcode part, there was no feedback from
>> either command.  So did I, or did I not do this as I was and am running
>> 2.6.28.7?  The following was reported in my log:
>
>modprobe generally doesn't return much if the module in question loads
>or (as in this case because you were using -r) is removed. That's the
>typical Unix command line behviour - no response/output on "OK".
>
>> Mar  9 07:22:04 coyote kernel: [65725.855365] platform microcode:
>> firmware: requesting amd-ucode/microcode_amd.bin Mar  9 07:22:04 coyote
>> kernel: [65725.863101] microcode: size 1936, total_size 960 Mar  9
>> 07:22:04 coyote kernel: [65725.863107] microcode: CPU3 patch does not
>> match (processor_rev_id: 1020, eqiv_cpu_id: 1022) Mar  9 07:22:04 coyote
>> kernel: [65725.863110] microcode: size 968, total_size 960 Mar  9 07:22:04
>> coyote kernel: [65725.863120] microcode: CPU3 updated from revision
>> 0x1000065 to 0x1000083 Mar  9 07:22:04 coyote kernel: [65725.863122]
>> Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>>
>> Inquiring minds and all that.  Comments please?
>
>It looks like the firmware file (amd-ucode/microcode_amd.bin) doesn't
>match your processor. CC'ing Andreas for comment as you have an AMD
>machine...

Thank You.  But the text report above also says it did update it, hence the 
confusion.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
For fast-acting relief, try slowing down.

