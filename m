Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbZI2Oib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbZI2Oib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZI2Oia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:38:30 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:36917 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZI2Oi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KZaR7A+Gvl5XfCOAJ6MmaJPVxyxUlzPiu5IDAqzA5wH68tvrpufE4i61a4d/oFBrHl
         yNQB5M7Nx3zZ4d4Sv/HwCT0JDGt8sxujuZDOd1APrz3S8cAE/ZGrsIWtLRIKCg8tItFO
         uisoFpoZrfWcfMP47sHpFhBlfE/wH4Yxb6Lfs=
MIME-Version: 1.0
In-Reply-To: <20090929072454.GA11414@elte.hu>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	 <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
	 <20090929072454.GA11414@elte.hu>
Date: Tue, 29 Sep 2009 16:38:32 +0200
Message-ID: <8db1092f0909290738o217fc231t8b6d0d698ff0844c@mail.gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
	__sysdev_resume+0xc3/0xe0()
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/29 Ingo Molnar <mingo@elte.hu>:
>
> * Yong Zhang <yong.zhang0@gmail.com> wrote:
>
>> On Sun, Sep 27, 2009 at 4:05 PM, Maciej Rutecki
>> <maciej.rutecki@gmail.com> wrote:
>> > Kernel: 2.6.31-git17
>> >
>> > During suspend to disk & resume I got it in dmesg:
>> >
>> > [  587.940010] ------------[ cut here ]------------
>> > [  587.940010] WARNING: at kernel/hrtimer.c:648 hres_timers_resume+0x40/0x50()
>> > [  587.940010] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
>> > [  587.940010] hres_timers_resume() called with IRQs enabled!
>> > [  587.940010] Modules linked in: btusb i915 drm_kms_helper drm
>
> Could you try this with .32-rc1? This commit should have fixed the
> message above:
>
> 89133f9: clocksource: Resume clocksource without taking the clocksource mutex
>
>        Ingo
>

Dmesg:
http://unixy.pl/maciek/download/kernel/2.6.31-git17/gumis/dmesg-2.6.32-rc1.txt
(s2disk and resume)
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
