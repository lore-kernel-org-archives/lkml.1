Return-Path: <linux-kernel-owner+w=401wt.eu-S965224AbXBFDF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965224AbXBFDF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965242AbXBFDF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:05:29 -0500
Received: from 60-248-88-209.HINET-IP.hinet.net ([60.248.88.209]:51891 "EHLO
	areca.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965224AbXBFDF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:05:29 -0500
X-Greylist: delayed 1418 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 22:05:28 EST
Message-ID: <000501c74998$79b41490$4e00a8c0@erich2003>
From: "erich" <erich@areca.com.tw>
To: "Igmar Palsenberg" <i.palsenberg@jdi-ict.nl>
Cc: "Andrew Morton" <akpm@osdl.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>, <npiggin@suse.de>
References: <Pine.LNX.4.58.0611291329060.18799@jdi.jdi-ict.nl> <20061130212248.1b49bd32.akpm@osdl.org> <Pine.LNX.4.58.0612010926030.31655@jdi.jdi-ict.nl> <Pine.LNX.4.58.0612042201001.14643@jdi.jdi-ict.nl> <Pine.LNX.4.58.0612061615550.24526@jdi.jdi-ict.nl> <20061206074008.2f308b2b.akpm@osdl.org> <Pine.LNX.4.58.0612070940590.28683@jdi.jdi-ict.nl> <Pine.LNX.4.58.0612071328030.9115@jdi.jdi-ict.nl> <Pine.LNX.4.58.0612140912010.30202@jdi.jdi-ict.nl> <20061214004213.13149a48.akpm@osdl.org> <Pine.LNX.4.58.0612140953080.9623@jdi.jdi-ict.nl> <20061214011042.7b279be6.akpm@osdl.org> <Pine.LNX.4.58.0702051118230.30521@jdi.jdi-ict.nl>
Subject: Re: 2.6.16.32 stuck in generic_file_aio_write()
Date: Tue, 6 Feb 2007 10:42:38 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.2826
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.2826
X-OriginalArrivalTime: 06 Feb 2007 02:40:41.0062 (UTC) FILETIME=[31145060:01C74998]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Igmar Palsenberg,

I can not make sure it is hardware problem, but I have interest in this 
case's reproducing.
If you tell me your platform's construction, I will try it and give you good 
solution.
Does your RAID adapter's firmware version work on 1.42?
Areca firmware had fix some hardware bugs and rare sg length handle in this 
version.

Best Regards
Erich Chen

----- Original Message ----- 
From: "Igmar Palsenberg" <i.palsenberg@jdi-ict.nl>
To: "Andrew Morton" <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>; <npiggin@suse.de>; "erich" 
<erich@areca.com.tw>
Sent: Monday, February 05, 2007 6:24 PM
Subject: Re: 2.6.16.32 stuck in generic_file_aio_write()


>
>> Does the other machine have the same problems?
>
> It does. It seems to depend on the interrupt frequency : Setting 
> KERNEL_HZ=250
> makes it ony appear once a month or so, with KERNEL_HZ=1000, it will
> occur within a week. It does happen a lot less with the other machine,
> which isn't under disk activity load as much as the other machine.
>
>> Are you able to rule out a hardware failure?
>
> Well.. It's too much coincidence that 2 (almost identical) machines show
> the same weard behaviour. What strikes me that only *disk* interrupts
> after a while don't get handled. The machine itself is alive, just all
> disk IO is blocked, which makes it pretty much useless.
>
> Erich, could this be some sort of hardware problem ? I know it's a PITA to
> reproduce, but setting CONFIG_HZ to 1000 and bashing the machine with
> diskactivity seems to help :)
>
>
> Regards,
>
>
> Igmar
>
> -- 
> Igmar Palsenberg
> JDI ICT
>
> Zutphensestraatweg 85
> 6953 CJ Dieren
> Tel: +31 (0)313 - 496741
> Fax: +31 (0)313 - 420996
> The Netherlands
>
> mailto: i.palsenberg@jdi-ict.nl 

