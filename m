Return-Path: <linux-kernel-owner+w=401wt.eu-S1765360AbYEIQcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765360AbYEIQcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYEIQcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:32:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:59964 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbYEIQcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=agh6ipWFRqXiFMJ5+vaIohyLfkrY0t90+6u0BlASb+ecQIqjcSxjjWET2a1tOT4+5txrT0lzpYNYdrCaivDF9EA94VV2tPL/+qICu49LA4BcYS32mw39xr/8YvRuxjARbVQIvIXMfqTFQb6d79Uo4ipTt0DTnW6q6inMc7VnyVQ=
Message-ID: <48247CBF.3070000@googlemail.com>
Date: Fri, 09 May 2008 18:33:03 +0200
From: brot <schnitzelkuchen@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel-testers - finding regressions in the kernel
References: <20080507195830.GC32750@cs181133002.pp.htv.fi> <804dabb00805080712h6d8c282dy5efff381298acfeb@mail.gmail.com> <55f47b0b0805081043y701b406awa2087b875a7e040e@mail.gmail.com> <4823769A.1040809@googlemail.com> <20080508230543.GL22887@cs181133002.pp.htv.fi> <48241184.2070107@googlemail.com> <482421D2.9060103@googlemail.com>
In-Reply-To: <482421D2.9060103@googlemail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

brot wrote:
> 
> I found the specific load. I am running prime torture test, in mode 2:
> 
> 2 = In-place large FFTs (maximum heat and power consumption, some RAM
> tested)
> 
> 1 thread per cpu.
> 
> Prime can be downloaded from:
> http://www.mersenneforum.org/showthread.php?t=9779
> 
> While that test is running, i compile gtkmm-2.12.7 with -j3. I
> remembered that while i had to compile it i really had problems typing.
> And it looks like i was right. in 2.6.25.1 i had some skips in amarok
> while playing an mp3 (just normal short skips, but clearly noticable).
> My typing in kvirc looked like that:
> 
> 
> [11:07:41] <!brot> und nu laggds keyboard auch, aber nur
> manchmaaaaaaaaaaaaaaal
> (..)
> [11:09:18] <!brot> ichh  ababer auch priiiiiiiiiiiiime laaufen
> 
> That happens during normal typing, then i see that kvirc has "stuck" and
> can type normally. then the key during the lagg is repeated like you can
> see above and the other keys i typed are normal again.
> 
> In 2.6.24.3 there is no such problem, so i am starting a bisect test now.
> 
> Have a nice day everyone.
> brot

Just in case you want to know how i distinguished good from bad kernels, and how to reproduce those laggs.

Thanks,
brot


