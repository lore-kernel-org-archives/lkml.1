Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbXLKLlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbXLKLlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 06:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXLKLkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 06:40:53 -0500
Received: from hosted01.westnet.com.au ([203.10.1.211]:37832 "EHLO
	hosted01.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbXLKLkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 06:40:52 -0500
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 06:40:52 EST
Message-ID: <475E718A.5080001@snapgear.com>
Date: Tue, 11 Dec 2007 21:16:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bernd Schmidt <bernds_cb1@t-online.de>
CC: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       penguin-kernel@I-love.SAKURA.ne.jp, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp> <20071202134841.GI15974@stusta.de> <20071203153459.ac19dae3.akpm@linux-foundation.org> <20071206210248.GN15974@stusta.de> <475E6A99.1050800@t-online.de>
In-Reply-To: <475E6A99.1050800@t-online.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt wrote:
> A couple of Cc:s added.
> 
> Adrian Bunk wrote:
>> On Mon, Dec 03, 2007 at 03:34:59PM -0800, Andrew Morton wrote:
>>> On Sun, 2 Dec 2007 14:48:42 +0100
>>> Adrian Bunk <bunk@kernel.org> wrote:
>>>
>>>> On Sun, Dec 02, 2007 at 05:43:39PM +0900, Tetsuo Handa wrote:
>>>>> mm/slub.c exports ksize(), but mm/slob.c and mm/slab.c don't. I don't know why.
>>>>> ...
>>>> That's due to the fact that my patch to remove this unused export from 
>>>> slub was not yet applied...
>>>>
>>>> Where is the modular in-kernel user?
>>>>
>>> binfmt_flat.c, binfmt_elf_fdpic.c.
>> I could have sworn I had checked that both are bools, but BINFMT_FLAT is 
>> actually a tristate.
>>
>> Is anyone actually using binfmt_flat modular (considering it's only 
>> available for !MMU embedded systems)? If yes, then only exporting 
>> ksize() will not be enough for getting it working modular...
> 
> We're not using modular binfmt_flat on the Blackfin, but I can't speak
> for other architectures.

I don't know of any architectures that do (or have ever) used
these as modules.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
