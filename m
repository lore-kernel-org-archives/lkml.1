Return-Path: <linux-kernel-owner+w=401wt.eu-S1761848AbYENOYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761848AbYENOYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759310AbYENOYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:24:07 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:38285 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbYENOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:24:05 -0400
Message-ID: <482AF60F.5050002@grupopie.com>
Date: Wed, 14 May 2008 15:24:15 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Vegard Nossum <vegard.nossum@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kallsyms: fix potential overflow in binary search
References: <20080513200736.GA17909@damson.getinternet.no>	 <482AD08D.7070206@grupopie.com> <84144f020805140522m6136ff69w7ffa6f9c9248706f@mail.gmail.com>
In-Reply-To: <84144f020805140522m6136ff69w7ffa6f9c9248706f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Wed, May 14, 2008 at 2:44 PM, Paulo Marques <pmarques@grupopie.com> wrote:
>>> This will probably never trigger... but it won't hurt to be careful.
>>  Not "probably", this will never trigger _period_. If you ever have more
>> than 2^31 symbols in the kernel's kallsyms table you'll have worse problems
>> to worry about than the binary search overflowing.
>>
>>  So, I don't think it is worth this des-optimization at all...
> 
> Yes it is. It serves as correct reference code and the
> "deoptimization" is not measurable.

Hum? "reference code"? in the middle of a kallsyms function?

And are you really worried about contiguous arrays that are bigger than 
2^31 elements? What kind of kernel structure would that be?

The fact that the "deoptimization" isn't measurable isn't an excuse for 
unnecessary bloat.

This all seems like a wild goose chase to me...

-- 
Paulo Marques - www.grupopie.com

"To be, or not to be? That is ..... liable to be removed at -O2 and above."
