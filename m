Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbZFKKwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbZFKKwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbZFKKwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:52:41 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:35285 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759069AbZFKKwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:52:41 -0400
Message-ID: <4A30E1F8.3090806@snapgear.com>
Date: Thu, 11 Jun 2009 20:52:40 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-am33-list@redhat.com,
       yasutake.koichi@jp.panasonic.com
Subject: Re: [git-pull -tip] headers_check fix patches 20090610
References: <1244640630.20890.22.camel@ht.satnam>	 <20090611001957.61b5530b.sfr@canb.auug.org.au>	 <1244647176.3070.8.camel@ht.satnam>  <4A305F7C.9000308@snapgear.com> <1244715961.6923.8.camel@ht.satnam>
In-Reply-To: <1244715961.6923.8.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jaswinder,

Jaswinder Singh Rajput wrote:
> On Thu, 2009-06-11 at 11:35 +1000, Greg Ungerer wrote:
>> Hi Jaswinder,
>>
>> Jaswinder Singh Rajput wrote:
>>> Hello Stephen,
>>>
>>> On Thu, 2009-06-11 at 00:19 +1000, Stephen Rothwell wrote:
>>>> Hi Jaswinder,
>>>>
>>>> On Wed, 10 Jun 2009 19:00:30 +0530 Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
>>>>> The following changes since commit e271e1343a94e081723cb4180af3fdb5fecc1a49:
>>>>>   Ingo Molnar (1):
>>>>>         Merge branch 'x86/mce4'
>>>>>
>>>>> are available in the git repository at:
>>>>>
>>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-top.git master
>>>>>
>>>>> Jaswinder Singh Rajput (3):
>>>>>       headers_check fix: m68k, swab.h
>>>>>       headers_check fix: mn10300, ptrace.h
>>>>>       headers_check fix: mn10300, setup.h
>>>>>
>>>>>  arch/m68k/include/asm/swab.h      |    2 +-
>>>>>  arch/mn10300/include/asm/ptrace.h |    5 ++---
>>>>>  arch/mn10300/include/asm/setup.h  |    3 ++-
>>>>>  3 files changed, 5 insertions(+), 5 deletions(-)
>>>> Is there some reason that these fixes are not just sent to the appropriate linux-am33-list@redhat.com
>>>> maintainers?  That way we would avoid unnecessary conflicts cropping up.
>>>>
>>> Maintainers are also in CC.
>>> Patches were already sent on :
>>>
>>> Subject: [PATCH 0/6] headers_check fix patches 20090604
>>>
>>> Interested maintainers already pulled and applied patches. These are
>>> left-over patches. I am sending to Ingo hoping that he will merge it
>>> otherwise last option for me will be to prepare headers-check tree and
>>> send to linux-next ;-)
>> I am happy to take the m68k change and push that upstream.
>> If it hasn't already been picked up by someone else.
>>
> 
> Sure, take it.

Ok, done. That one m68k patch is now in:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

I will be pushing that to Linus some time in the next few days.

Regards
Greg



> So now only mn10300 patches left :-)
> 
> Thanks,
> --
> JSR
> 
> 


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
