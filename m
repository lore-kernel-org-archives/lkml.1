Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYKIOwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYKIOwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 09:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYKIOwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 09:52:25 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:59830 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbYKIOwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 09:52:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dNNDi8voEwg6J7GEtrPre2ylTmie/tNtbQwETMyK6+kvdCI3zQ0JuDQi1nwP56xOx1
         eL/OX5B7iKasFfyS02S1y+odQM7eP9vF8s2e9B/n/rXtWRkhZZI8FA7JrupXhCZ5N0Po
         JVyAmUmpA8TKMMbx4B726pQTlNOGaztv9aifY=
Message-ID: <bc64b4640811090652l36991377v26d7be4789a9b810@mail.gmail.com>
Date: Sun, 9 Nov 2008 17:52:22 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Cc: "Eric Miao" <eric.y.miao@gmail.com>, "Cyril Hrubis" <metan@ucw.cz>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Russell King" <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, thommycheck@gmail.com
In-Reply-To: <20081109141249.GC1786@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105173303.GC2038@elf.ucw.cz> <20081106080416.GA1531@ucw.cz>
	 <20081106191424.GA2273@atrey.karlin.mff.cuni.cz>
	 <f17812d70811070523k59a57d49tac1ab1e5b78d1db4@mail.gmail.com>
	 <20081107142923.GA1616@ucw.cz>
	 <bc64b4640811070657p668dcaedrfd442b0d439b3c78@mail.gmail.com>
	 <20081109114545.GG6094@elf.ucw.cz> <20081109114640.GA10733@elf.ucw.cz>
	 <bc64b4640811090430m195c421ejbf08375f4d9afd09@mail.gmail.com>
	 <20081109141249.GC1786@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/9 Pavel Machek <pavel@suse.cz>:
> On Sun 2008-11-09 15:30:17, Dmitry wrote:
>> 2008/11/9 Pavel Machek <pavel@suse.cz>:
>> > On Sun 2008-11-09 12:45:45, Pavel Machek wrote:
>> >> On Fri 2008-11-07 17:57:33, Dmitry wrote:
>> >> > 2008/11/7 Pavel Machek <pavel@suse.cz>:
>> >> > > On Fri 2008-11-07 21:23:41, Eric Miao wrote:
>> >> > >> Well, IIRC spitz still needs the patch to change the vmlinux.ld.S.
>> >> > >> Did you guys ever try that?
>> >> > >
>> >> > > I never heard about that patch, do you have it handy?
>> >> >
>> >> > http://rpsys.net/openzaurus/patches/archive/pxa-linking-bug.patch
>> >> >
>> >> > I plan to submit a bit modified version of this patch later.
>> >>
>> >> Could you send me full .config that is known to work?
>> >>
>> >> Do I need pxa-linking-bug.patch to get it to boot?
>> >
>> > (Note that I'm booting using kexec, not sharp bootloader).
>>
>> It seems that neither kexec, nor qemu require pxa-linking-bug.patch
>>
>> Attached a .config that I use for testing. It contains all sharp zaurii
>> selected, however you can easily deselect unnecessary ones.
>
> It should still boot on spitz, right? I'd rather not touch that
> .config...

It boots under qemu spitz emulation. No real HW of SL-CXX00 yet :(

-- 
With best wishes
Dmitry
