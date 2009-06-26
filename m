Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbZFZNZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbZFZNZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 09:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZFZNZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 09:25:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:4305 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbZFZNZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 09:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,296,1243839600"; 
   d="scan'208";a="425536442"
From: "Ma, Ling" <ling.ma@intel.com>
To: Dave Airlie <airlied@gmail.com>, Gabriel C <nix.or.die@googlemail.com>
CC: Dave Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
Date: Fri, 26 Jun 2009 21:25:33 +0800
Subject: RE: [git pull] drm fixes + intel display port
Thread-Topic: [git pull] drm fixes + intel display port
Thread-Index: Acn17R5sCeWG4mp8R1COX1c1CzSIuwActEKg
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7701E6AAB162@PDSMSX501.ccr.corp.intel.com>
References: <alpine.DEB.2.00.0906240723420.18292@skynet.skynet.ie>
	 <1820d69d0906240715v6c3591c4x30ee87e9ec8774f7@mail.gmail.com>
	 <4A4238D2.2060501@googlemail.com>
 <21d7e9970906251631h272607d6scee36997a0c574ab@mail.gmail.com>
In-Reply-To: <21d7e9970906251631h272607d6scee36997a0c574ab@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5QDQV54000500

>-----Original Message-----
>From: Dave Airlie [mailto:airlied@gmail.com]
>Sent: 2009å¹´6æœˆ26æ—¥ 7:32
>To: Gabriel C
>Cc: Dave Airlie; Ma, Ling; LKML; Keith Packard; Eric Anholt
>Subject: Re: [git pull] drm fixes + intel display port
>
>On Thu, Jun 25, 2009 at 12:31 AM, Gabriel C<nix.or.die@googlemail.com> wrote:
>> [ forgot to CC LKML , sorry ]
>>
>> Gabriel C wrote:
>>
>>> 2009/6/24 Dave Airlie <airlied@linux.ie>:
>>>> Hi Linus,
>>>>
>>>> Please pull the 'drm-fixes' branch from
>>>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
>drm-fixes
>>>>
>>>
>>> Hi Dave ,
>>>
>>> I own an DQ45CB Intel motherboard. When enabling KMS with kernels from
>>> 2.6.29* to current git / linux-next on that board
>>> I don't get any console. My Monitor is saying 'No signal' , however
>>> once X starts up I can login in KDE/gnome etc.
>>>
>>> The monitor is connected with an DVI-I -> VGA connector.
>>>
>>> I found on the gfx mailing list the following patch from Ma Ling :
>>>
>>> http://lists.freedesktop.org/archives/intel-gfx/2009-May/002504.html
>>>
>>> which seems to fix my problem. With that patch applied I get a console
>>> and everything works fine.
>>>
>>> However I still have such :
>>>
>>> [ Â  21.205449] i2c-adapter i2c-1: unable to read EDID block.
>>> [ Â  21.205452] i915 0000:00:02.0: VGA-1: no EDID data
>>>
>>>
>>> messages in my dmesg but it works.
>>>
>>>
>>> Is there any reason why this patch never got merged ?
>
>I don't think that patch is totally correct, it looks more like a lets
>try everything approach, I'll cc more Intel folks and see what they can do.
>
>Dave.
>
Yes, I have refined the patch [Resend][PATCH 1/4] drm/i915: crt fetch EDID by DVI-I converter on G4x platform, and  re-sent to mailing list. In that version we specified G4x platform which used GPIOD as port, which is wired to I2C bus of VGA or HDMI. Any comments from Eric?
Thanks
Ma Ling
>>>
>>> Best Regards,
>>>
>>> Gabriel C
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at Â http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at Â http://www.tux.org/lkml/
>>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
