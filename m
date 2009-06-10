Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbZFJEej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbZFJEej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 00:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZFJEeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 00:34:31 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:42797 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885AbZFJEeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 00:34:31 -0400
Message-ID: <4A2F37D6.40904@snapgear.com>
Date: Wed, 10 Jun 2009 14:34:30 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Oskar Schirmer <os@emlix.com>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, jw@emlix.com, dhowells@redhat.com,
       rmk@arm.linux.org.uk, cooloney@kernel.org, geert@linux-m68k.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3] flat: fix data sections alignment
References: <E1LfGwO-0007Kq-6c@mailer.emlix.com>	 <20090310073350.GH10393@linux-sh.org>	 <20090402135343.d18d17a5.akpm@linux-foundation.org>	 <20090409142553.GA3330@emlix.com> <20090505140847.GB25409@emlix.com>	 <20090527114955.GA23343@emlix.com>	 <20090527134357.601c3c87.akpm@linux-foundation.org>	 <20090528000801.GA30594@linux-sh.org>	 <20090527171631.ed4de515.akpm@linux-foundation.org>	 <20090602141529.GA8325@emlix.com> <8bd0f97a0906021157pfad795dg9fc0ac0ed4f85d1c@mail.gmail.com>
In-Reply-To: <8bd0f97a0906021157pfad795dg9fc0ac0ed4f85d1c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Mike Frysinger wrote:
> On Tue, Jun 2, 2009 at 10:15, Oskar Schirmer wrote:
>> On Wed, May 27, 2009 at 17:16:31 -0700, Andrew Morton wrote:
>>> On Thu, 28 May 2009 09:08:02 +0900
>>> Paul Mundt <lethal@linux-sh.org> wrote:
>>>> On Wed, May 27, 2009 at 01:43:57PM -0700, Andrew Morton wrote:
>>>>> The patch had a fairly shaky start and it's been unclear to me that
>>>>> everyone is happy with it and has tested it.
>>>>>
>>>>>  arch/arm/include/asm/flat.h      |    3 --
>>>>>  arch/blackfin/include/asm/flat.h |    1
>>>>>  arch/h8300/include/asm/flat.h    |    1
>>>>>  arch/m32r/include/asm/flat.h     |    1
>>>>>  arch/m68k/include/asm/flat.h     |    1
>>>>>  arch/sh/include/asm/flat.h       |    1
>>>>>  fs/binfmt_flat.c                 |   46 ++++++++++++++++++++++++++-------------
>>>>>
>>>>> I guess ARM is the major architecture amongst that lot.  Have Russell
>>>>> and co had a decent look through this?
>>>>>
>>>> The problem here is that the ARM nommu people seem to have disappeared
>>>> shortly after getting their changes merged. I see no activity within the
>>>> kernel for ARM nommu since 2006.
>>> heh, OK.  Oskar touched it last, so he's now ARM nommu maintainer.
>> Well, I'ld need some test device for that purpose.
>> Someone around who can provide one?
> 
> seems a bit odd for a maintainer to not have any hardware ... at any
> rate, dont you have an ARM system ?  cant you just disable support for
> the MMU ?

The nommu support for arm is not complete in mainline.
(And that is why CONFIG_MMU is not a settable option in arm yet).

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
