Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbZK2Qry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbZK2Qry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 11:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZK2Qrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 11:47:53 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:49106 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZK2Qrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 11:47:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fj61P89G0l3MFGAMIIliYsXFhlu96T1Bo7qh6iIF9pCFv6EsPY3ddT02gVt54eBZzl
         batofU0EJ/1LB4vXXanK8zbkgq0cVrb+pbSzteP2DXEoZfE+4yA7i1OI9C3Ho5TLxFVo
         tf/fcWl5PCf7pKlxJG7ne4FG0XGhKI0PeATh8=
Message-ID: <4B12A5BC.5070109@gmail.com>
Date: Sun, 29 Nov 2009 10:47:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Bruno Barberi Gnecco <brunobg@gmail.com>
CC: Michael Breuer <mbreuer@majjas.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: BUG: Constant freezes and kernel panics on a quad core
   (with dumps)
References: <4B119D95.6090806@gmail.com> <4B119DD7.8020303@majjas.com> <4B1298B0.1050505@gmail.com>
In-Reply-To: <4B1298B0.1050505@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2009 09:52 AM, Bruno Barberi Gnecco wrote:
>> I'd think this is a hardware problem. Some things that have caused me
>> similar grief in the past:
>
> It is possible, but I can rule most of them out. I think it's unlikely.
>
>> Bad IDE cable
>> Bad SATA cable
>
> Ruled out. Only SATA drives. I used two different HDs (separatedly) with
> different cables, and the live CD. It's not the cables or the drives.
>
>> Bad power supply
>> Bad motherboard
>
> Both are brand new, but of course that doesn't rule them out.

Checked CPU temperature under load?

>
> Regarding the PS, I have checked voltages with a multimeter and they are
> more than fine, and the wattage is enough for the system, so it'd have
> to be a very weird transient glitch that affects only memory access. See
> also below.

Most of the time transients will be the issue when a power supply causes 
problems and that can't be seen with a normal voltmeter. It's not 
typical for the rails to be low all the time unless the power supply is 
heavily overloaded.

>
> Any ideas to rule the MB out, other than "get a new one"?
>
>> Bad memory (memtest doesn't necessarily access things the same way as
>> the kernel)
>
> Ruled out. I replaced with a 2GB DDR2, still got the bug: "BUG: Bad page
> map in process".
>
>> Bad cards (pci, agp, whatever)
>
> Ruled out. The only card is the video card. I replaced it with a very
> old PCI board and still got error. This also pretty much rules out that
> the PS is underpowered, since I powered only the MB and the HD.
>
> Could it be one of the onboard things? I disabled everything but the
> LAN, and still got it.
>
>> Any of the above with loose connections
>
> I already reconnected everything twice. Could still be a loose
> connection of one of the wires in the connector, but it's very very
> unlikely to give such a specific error on memory access.
>
>> And did I mention bad power supply?
>
> Yes you did, and I'll try to get another one to be sure, but it could
> still be a software bug too.
>
> I tried to install an old Win2K I had here. It doesn't handle the big HD
> well and ends up not booting after installation (it can't partition it,
> also), but it didn't freeze (even though it formatted the disk and
> copied the files, which was not slow). So +1 to being a kernel bug.
>
> The most common error message I get is: "BUG: unable to handle kernel
> NULL pointer dereference."

If you're getting random crashes in different places then it usually is 
some kind of hardware problem, unless there's some kind of random memory 
corruption going on, but that seems a bit unlikely.
