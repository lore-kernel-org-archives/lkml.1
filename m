Return-Path: <linux-kernel-owner+w=401wt.eu-S934049AbXC0Fyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049AbXC0Fyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934052AbXC0Fyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:54:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:20554 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934000AbXC0Fyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jhv4rQGFEgaST5zuAfE889i4ltXvxc0U/mQq+U4PB4bwaaW6R1mjbJzxGVL1ge3HRIiIhSlLu73kDhl0uOG4p2SkxD0BoU02O+buqQ+mjcE/lzRd/6yF+pU2OxPzpvYkkeMRHOeauPwrNyXBAF03Cc2dKL7+HQi1E8kOQQIplzo=
Message-ID: <4608B1A2.3040305@gmail.com>
Date: Tue, 27 Mar 2007 14:54:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan <alan@lxorguk.ukuu.org.uk>, Len Brown <lenb@kernel.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: ATA ACPI (was Re: Linux 2.6.21-rc5)
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <4608B0CA.1040005@garzik.org>
In-Reply-To: <4608B0CA.1040005@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Linus Torvalds wrote:
>> There's various fixes here, ranging from some architecture updates 
>> (ia64, ARM, MIPS, SH, Sparc64) to KVM, networking and network drivers.
>>
>> And random one-liners.
>>
>> But probably more important, and likely much more visible to most 
>> people is the fixes for the fallout from the hrtimers and no-HZ 
>> changes, and some of the ACPI regressions.
>>
>> Those timer changes ended up much more painful than anybody wished 
>> for, but big thanks to Thomas Gleixner for being on it like a weasel 
>> on a dead rat, and the regression list has kept shrinking.
>>
>> So if you have reported a regression in the 2.6.21-rc series, please 
>> check 2.6.21-rc5, and update your report as appropriate (whether fixed 
>> or "still problems with xyzzy").
>>
>>         Linus
> 
> 
> [just got back from vacation, or would have sent this earlier]
> 
> FWIW, I'm still leaning towards disabling libata ACPI support by default 
> for 2.6.21.
> 
> Upstream has Alan's fix for the worst PATA problems, but for different 
> reasons, I think PATA ACPI and SATA ACPI support in libata does not feel 
> quite ready for prime time in 2.6.21.
> 
> Scream now, or hold your peace until 2.6.22... :)

I second disabling ACPI for 2.6.21.

-- 
tejun
