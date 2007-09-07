Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbXIGFtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbXIGFtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 01:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXIGFtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 01:49:31 -0400
Received: from smtpoutm.mac.com ([17.148.16.71]:50179 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbXIGFta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 01:49:30 -0400
In-Reply-To: <1189142049.6681.29.camel@heimdal.trondhjem.org>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr> <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org> <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in> <20070906150616.GA28565@fieldses.org> <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com> <1189121714.6672.38.camel@heimdal.trondhjem.org> <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com> <1189142049.6681.29.camel@heimdal.trondhjem.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3BBEDBBC-FD71-4A6F-81B3-EC0978A37024@mac.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Satyam Sharma <satyam@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: NFS4 authentification / fsuid
Date: Fri, 7 Sep 2007 01:47:28 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 07, 2007, at 01:14:09, Trond Myklebust wrote:
> On Thu, 2007-09-06 at 20:56 -0400, Kyle Moffett wrote:
>> Umm, I did say "encrypt the root filesystem", didn't I?  Booting  
>> my laptops this way follows this procedure:
>>    1) Enter BIOS boot menu
>>    2) Insert /boot CDROM
>>    3) Select the "CDROM" entry
>>    4) Wait for kernel to start and run through initramfs
>>    5) Type password into the initramfs prompt so that it can  
>> DECRYPT THE ROOT FILESYSTEM
>>    6) Continue to boot the system.
>>
>> [...] the only avenues of attack are strictly of the "Install a  
>> hardware keylogger" variety.
>
> So an attacker will instead install a hardware keylogger, or swap  
> out your boot cdrom with a compromised but almost identical boot  
> cdrom instead, or mod your bios, ...
>
> A fully self-certifying system that can prevent any attack is  
> _very_ hard to achieve. Just ask apple (iPhone) or any games  
> console vendor...

A fully self-certifying system that can prevent any attack is  
impossible to achieve.  If I have the device and can devote as many  
hours as I want to breaking into it, there is exactly ZERO way to  
prevent that, aside from encrypting things and not giving out the key  
(which sorta makes it useless but is precisely the point of real  
crypto).

There is a HUGE difference between "I don't want the end-user to hack  
into this" and "The end-user wants a certain degree of assurance that  
his data can't be compromised.  In the former case (IE: DRM) you are  
NOT using cryptography because you are giving the user: (A) the data,  
(B) the algorithm, and (C) the key, which means they can decrypt it  
ANY TIME THEY WANT.  In the latter case the attacker DOES NOT have  
the key and virtually all of the attacks forms of "How do I get the  
key?".  The end-user is REQUIRED to provide an appropriate level of  
physical security based on the nature of the data;  If I'm that  
worried about somebody substituting my /boot CD, then I'm going to  
make DAMN sure that I keep it on my person at all times.

So you can't draw any relationships between "Protect the end-user"  
with "Protect the device FROM the end-user", the former can be done  
very reliably to whatever level of risk-reduction you need and the  
latter can't practically be done at all.

Cheers,
Kyle Moffett
