Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbYD2H3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbYD2H3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759915AbYD2H1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:27:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:58588 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760270AbYD2H1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=FLbzF1gRRR8NNe4QxmfO0xaznuoqQXBpRbtGmjd+TX5dR4d2asm1fyKAq63kFe0joA4BTUwQJG0oU9p8CR6UYrZ4ofKv75xchphElZXQ1jjOF163wHk31/9Beloq3+eHgc1N3ZdfPhZ5fMd5okc8ArU0insDb8ei2GE/2Gp6A58=
Message-ID: <4816CDCF.50100@gmail.com>
Date: Tue, 29 Apr 2008 08:27:11 +0100
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

Sorry,

I sent my previous mail too eagerly..

2.6.22 worked
2.6.23 not tested
2.6.24 broken

I will grab a .23 kernel and see if its problem too :-P

R

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

