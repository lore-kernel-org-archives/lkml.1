Return-Path: <linux-kernel-owner+w=401wt.eu-S937399AbXHMTj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937399AbXHMTj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbXHMTjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:39:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51052 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbXHMTjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:39:43 -0400
Message-ID: <46C0B468.8000608@oracle.com>
Date: Mon, 13 Aug 2007 12:43:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Adrian Bunk <bunk@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, sam@ravnborg.org,
       zippel@linux-m68k.org, vincent.legoll@gmail.com
Subject: Re: [PATCH] kconfig: update kconfig-language text
References: <20070813113809.9a715e75.randy.dunlap@oracle.com> <20070813185431.GD18945@stusta.de> <Pine.LNX.4.64.0708131510140.14058@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0708131510140.14058@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Mon, 13 Aug 2007, Adrian Bunk wrote:
> 
>> On Mon, Aug 13, 2007 at 11:38:09AM -0700, Randy Dunlap wrote:
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> Add kconfig-language docs for mainmenu, def_bool[ean],
>>> and def_tristate.
>>>
>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>> Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
>>> ---
>>>  Documentation/kbuild/kconfig-language.txt |   12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>> --- linux-2.6.23-rc3.orig/Documentation/kbuild/kconfig-language.txt
>>> +++ linux-2.6.23-rc3/Documentation/kbuild/kconfig-language.txt
>>> @@ -77,6 +77,11 @@ applicable everywhere (see syntax).
>>>    Optionally, dependencies only for this default value can be added with
>>>    "if".
>>>
>>> +- type definition + default value:
>>> +	"def_bool"/"def_boolean"/"def_tristate" <expr> ["if" <expr>]
>>> ...
>> Should the redundant and unused def_boolean be documented or removed?
>>
>> I'd prefer the latter.
> 
> me too.  and, as i've suggested before, it would also be cleaner to
> remove the redundant "requires" and almost redundant "depends" from
> Kconfig files, and standardize exclusively on "depends on".
> 
> at the moment, there are only five Kconfig files that use the far less
> common "depends" directive:
> 
> ./drivers/telephony/Kconfig:    depends ISA || PCI
> ./drivers/leds/Kconfig: depends LEDS_CLASS && ARCH_H1940
> ./drivers/input/misc/Kconfig:   depends EXPERIMENTAL
> ./arch/blackfin/Kconfig:        depends BFIN_DMA_5XX
> ./arch/powerpc/platforms/Kconfig:       depends PPC_IBM_CELL_BLADE
> 
> adjust those and there's no reason to hang on to "depends" any longer.
> 
> rday

but what problem are these?  what is solved by these changes?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
