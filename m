Return-Path: <linux-kernel-owner+w=401wt.eu-S1765840AbYETNZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765840AbYETNZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYETNZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:25:07 -0400
Received: from mailgw.cs.york.ac.uk ([144.32.40.3]:57354 "EHLO
	mailgw.cs.york.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbYETNZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:25:05 -0400
X-Greylist: delayed 1744 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 09:25:05 EDT
Message-ID: <4832C957.8040004@student.cs.york.ac.uk>
Date: Tue, 20 May 2008 13:51:35 +0100
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Reply-To: alan-jenkins@tuffmail.co.uk
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Loading DSDT from initrd, can it be done from grub instead?
References: <avxTs-570-21@gated-at.bofh.it>    <12bd24d7-17d4-4df8-abca-42740ec309fe@x35g2000hsb.googlegroups.com> <54484.145.64.134.222.1211286021.squirrel@www.hardeman.nu>
In-Reply-To: <54484.145.64.134.222.1211286021.squirrel@www.hardeman.nu>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Härdeman wrote:
> On Tue, May 20, 2008 13:58, Alan Jenkins wrote:
>   
>> David Härdeman wrote:
>>     
>>> In commit 9a9e0d685553af76cb6ae2af93cca4913e7fcd47 the
>>> ACPI_CUSTOM_DSDT_INITRD option was removed.
>>>
>>> I was wondering if it'd be feasible to hack grub to load a custom DSDT
>>> instead (since grub can read filesystems) and then pass a pointer to a
>>> memory location containing the DSDT to the kernel?
>>>       
>> Um, why?  What stops you from reverting the offending commit?
>>     
>
> Because doing it from grub (if possible) would allow custom DSDT's to be
> loaded without patching the kernel (e.g. allows distro kernels to be used)
> and without introducing code that opens files from kernel space and mucks
> with both the VFS and ACPI in ugly ways?
>
>   
>> Without further info, I'd assume the feature was removed on policy
>> grounds.  I.e. it's not nice to be effectively patching the BIOS
>> yourself, and vendors have fixed most of their BIOS's / linux is
>> slightly more tolerant to broken ones. I don't know whats wrong with
>> reading files from the initrd.
>>     
>
> If you do not understand the issue at hand, why comment?
>   
Mea cupla.  Apologies if my tone was also inappropriate.

I saw a short question on an interesting subject, without a context to 
suggest an ongoing
conversation.  I would have saved myself some embarassment if I 
remembered that linux really doesn't like in-kernel filesystem access; I 
just didn't make the connection.

I guessed wrong, didn't see where you were coming from, and didn't take 
the effort to resolve the SHA commit id.  I literally don't have the 
space for a checkout on my main PC and I feel slightly guilty when I hit 
on the gitweb host.

Ironically, I just looked it up and Google knew what the SHA ID was.  
You might be interested to know that another DH (Dave Hansen) made the 
same suggestion, but using kexec instead of grub to load the DSDT and 
boot kernel.

Alan
