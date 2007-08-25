Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbXHYR7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbXHYR7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 13:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbXHYR73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 13:59:29 -0400
Received: from effinger.acpub.duke.edu ([152.3.232.59]:41968 "EHLO
	effinger.acpub.duke.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbXHYR72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 13:59:28 -0400
X-Greylist: delayed 6258 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2007 13:59:28 EDT
Date: Sat, 25 Aug 2007 12:15:07 -0400 (EDT)
From: rb6@duke.edu
X-X-Sender: rann@rann-gentoo
Reply-To: rb6@duke.edu
To: linux-kernel@vger.kernel.org
Subject: Re: Problem with CFS V20 and Suspend2/tuxonice
Message-ID: <alpine.LNX.0.999.0708251211480.9207@rann-gentoo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Same problem on my centrino duo.  Reverting to cfs v19 fixes it.

Please personally CC me on replies, as I am not on the list.


> Reproduced on a Intel Centrino based laptop with gentoo kamikaze7
> sources (http://forums.gentoo.org/viewtopic-t-577970.html)



> On 8/25/07, David Rodriguez <livuxman@gmail.com> wrote:
>> I'm using 2.6.22.5 with cfs v20.3 and  suspend2  2.2.10.2.
>> With that combination, suspend is not working anymore (with cfs v19
>> was working).
>> Stops on suspend in "Suspending tasks"
>> Looking at cfs patch, I managed to change the  migration_thread,
>> adding again the  try_to_freeze() removed in last patch and now the
>> suspend finished, but resume not work. Of course I don't know why that
>> was removed, and rewriting it is not a solution, but I want to report
>> it.
>>
>> All that in a core duo machine.
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" 
>in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" 
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
