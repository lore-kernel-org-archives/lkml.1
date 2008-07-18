Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbYGRUQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbYGRUQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYGRUQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:16:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38587 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbYGRUQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:16:16 -0400
Date: Fri, 18 Jul 2008 22:15:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       ALSA development <alsa-devel@alsa-project.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rene Herman <rene.herman@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [boot crash, bisected] in 9f240a55 "ALSA: opti93x: use cs4231
	lib"
Message-ID: <20080718201558.GA24122@elte.hu>
References: <Pine.LNX.4.61.0807141105150.7676@tm8103-a.perex-int.cz> <20080717170657.GA14593@elte.hu> <s5h3am8jqvy.wl%tiwai@suse.de> <487F9B9B.2010905@keyaccess.nl> <487F9FA1.7020101@keyaccess.nl> <48806017.1040307@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48806017.1040307@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 17-07-08 21:38, Rene Herman wrote:
>
>> On 17-07-08 21:20, Rene Herman wrote:
>>
>>> On 17-07-08 20:40, Takashi Iwai wrote:
>>>
>>>> Could you try the patch below?
>>>
>>> No, please hang on, it's much simpler. Above commit isn't actually  
>>> itself guilty. Have a patch ready, but am testing a bit.
>>
>> I retract that. Your patch should fix things.
>
> It does. Acked/Tested-by: Rene Herman <rene.herman@gmail.com>

box survived dozens of reboots so the fix from yesterday indeed did the 
trick.

thanks,

	Ingo
