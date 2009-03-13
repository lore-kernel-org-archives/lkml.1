Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbZCMUeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbZCMUeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 16:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZCMUeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 16:34:15 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:39940 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZCMUeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 16:34:14 -0400
Message-ID: <49BAC340.5030100@grupopie.com>
Date: Fri, 13 Mar 2009 20:34:08 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>, laijs@cn.fujitsu.com, mingo@elte.hu,
       srostedt@redhat.com, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] kallsyms, tracing: output more proper symbol name
References: <49B7863F.6020804@cn.fujitsu.com>	<20090311094621.GA13543@elte.hu>	<49B7B70F.5010908@grupopie.com>	<49B876BB.50007@cn.fujitsu.com>	<49B92B25.6020805@grupopie.com>	<49BA06E2.7080807@cn.fujitsu.com>	<49BA2704.9040404@cn.fujitsu.com>	<20090313194013.GA23304@uranus.ravnborg.org> <20090313130722.1d92ad80.akpm@linux-foundation.org>
In-Reply-To: <20090313130722.1d92ad80.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 13 Mar 2009 20:40:13 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
>>> This patch puts symbols like "__irqentry_text_start" to the second
>>> aliased symbols. And a more proper symbol name becomes the first.
>>>
>>> Aliased symbols mostly come from linker script. The solution is
>>> guessing "is this symbol defined in linker script", the symbols
>>> defined in linker script will not become the first aliased symbol.
>>>
>>> And if symbols are found to be equal in this "linker script provided"
>>> criteria, symbols are sorted by the number of prefix underscores.
>>>
>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> Looks good to me.
>>
>> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> So... do we need this in 2.6.29?

IMHO, no. I think the way the kernel handles aliased symbols hasn't
changed in a very long time so one more release shouldn't make a big
difference.

Even if the risk of the patch breaking something is small, taking that
chance for such a small gain this late in the 2.6.29 cycle is just not
worth it.

-- 
Paulo Marques - www.grupopie.com

"You're just jealous because the voices only talk to me."
