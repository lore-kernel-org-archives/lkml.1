Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXCVAP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXCVAP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965539AbXCVAP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:15:26 -0400
Received: from dkj137.neoplus.adsl.tpnet.pl ([83.24.13.137]:64969 "EHLO
	dkj137.neoplus.adsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965521AbXCVAP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:15:26 -0400
Message-ID: <4601CA9C.6050708@o2.pl>
Date: Thu, 22 Mar 2007 01:15:24 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 3.0a1 (X11/20070320)
MIME-Version: 1.0
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
CC: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: rsdl improvements
References: <200703220429.45311.kernel@kolivas.org> <4601BF45.7070708@o2.pl> <4601C44B.9060705@mnsu.edu>
In-Reply-To: <4601C44B.9060705@mnsu.edu>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrey Hundstad wrote:
>> I'm not sure this is going in the right direction... I'm writing
>> this while compiling a kernel w/ "nice -20 make -j2" and X is almost
>>   
> Did you mean "nice -20"?  If so, that should have slowed X quite a bit. 
> Try "nice 19" instead.

i did try "nice --20" too :) Resulted in long X stalls, but i don't
think that's a reasonable load so I did not mention it.
"nice -20 cmd" runs cmd at nice==19.

Usage: nice [OPTION] [COMMAND [ARG]...]
Run COMMAND with an adjusted niceness, which affects process scheduling.
With no COMMAND, print the current niceness.  Nicenesses range from
-20 (most favorable scheduling) to 19 (least favorable).

  -n, --adjustment=N   add integer N to the niceness (default 10)
