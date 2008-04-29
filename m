Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbYD2HSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbYD2HSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYD2HSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:18:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:42619 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYD2HSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=GVoLfyyWflYaen7HgoTGKPQlTWln+CMx7HjC/8WlaMaMbCtPowBG567/fwOsVm0xf+CAFrFpnLQlP4WWrnXz+8JrIbTzSkUdEFDTvvjiDTlfyOsmbBBgY9GZOZbPc4jwt7K3tDIg1xOwojFNpbJtJbAc+Ap/ebW0cBJfr/9vaVk=
Message-ID: <4816CBA1.4050907@gmail.com>
Date: Tue, 29 Apr 2008 08:17:53 +0100
From: Richard <tuxbox.guru@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Adam M Belay <abelay@mit.edu>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: Re: 2.6.25 pci=noacpi
References: <20080425183807.366134771@ldl.fc.hp.com>	<20080425183934.516655076@ldl.fc.hp.com>	<4813B5AB.4060308@keyaccess.nl>	<200804281507.38309.bjorn.helgaas@hp.com>	<4816C605.4000601@gmail.com> <20080429000411.ce73230f.akpm@linux-foundation.org>
In-Reply-To: <20080429000411.ce73230f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew/all

A stock standard 2.6.24 kernel worked fine, but it exhibited a problem 
where the timer sources didnt run as expected. ( I didnt put too much 
effort in to it as I wanted a hot off the press kernel ) in 2.6.24 the 
ACPI done its job :-)

I am going to enable netconsole to try see if it can throw me a bone.

Thanks,
Richard

Andrew Morton wrote:
> On Tue, 29 Apr 2008 07:53:57 +0100 Richard <tuxbox.guru@gmail.com> wrote:
>
>   
>> Hi all,
>>
>> Using an AMD Sempron notebook (HP Compaq 6715b) single processor 
>> machine,  It shuts down during bootup when ACPI is fully enabled.  I 
>> added pci=noacpi to the cmdline and it finally boots, but its extremely 
>> slow...  (kdm times out with error saying it took too long to load and 
>> disables graphical)
>>
>> Dmesg doest show anything out of the ordinary, irq_stats only shows the 
>> timer interrupts being incremented. (noirq also works, but same 
>> behaviour) Can someone please offer me some pointers so I can fault find 
>> this problem.
>>
>>     
>
> Did any earlier kernels work OK?  If so, which versions?
>
> Thanks.
>
>   

