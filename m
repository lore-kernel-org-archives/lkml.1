Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbZJALI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbZJALI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 07:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbZJALI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 07:08:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49073 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756307AbZJALIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 07:08:55 -0400
Date: Thu, 1 Oct 2009 13:08:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, mce: rename finished to valid in struct mce II
Message-ID: <20091001110850.GA32337@elte.hu>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com> <4AC05CFC.4020702@jp.fujitsu.com> <4AC0FF58.5040302@linux.intel.com> <4AC1C80F.8010904@jp.fujitsu.com> <4AC2926F.4080503@linux.intel.com> <4AC29645.1010209@zytor.com> <4AC2E103.5090707@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC2E103.5090707@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> H. Peter Anvin wrote:
>> On 09/29/2009 04:04 PM, Andi Kleen wrote:
>>> Hidetoshi Seto wrote:
>>>> Andi Kleen wrote:
>>>>> struct mce is exported to user space. I don't think it's a good idea
>>>>> to rename fields in exported structures like this.  That just causes confusion.
>>>> I don't know any other real user of this struct than the mcelog and the
>>>> mce test suite.  In other words, I expected that you (Huang and Andi) are
>>>> only users who may be confused by this kind of change.
>>> Also I should add there are other consumers of /dev/mcelog, not just
>>> mcelog/mce-inject.
>>>
>>
>> Details?
>
> e.g. mced

Am i the only one who finds Andi's reply and discussion methods in such 
matters utterly unproductive and intentionally obstructive?

Firstly, the initial sentence of:

  " Also I should add there are other consumers of /dev/mcelog, not just
    mcelog/mce-inject. "

Was IMO designed to be as unhelpful as possible, while still making his 
point. It would have been _so_ easy for Andi to be a bit more helpful to 
add this little bit of information to the sentence:

   "..., such as 'mced'."

A communication style like that sucks on lkml, a lot. It's vasteful 
(costs time) and is deceptive as well and holds up the technical 
discussion.

The "which are those?" basic question was to be expected, especially 
given that mced is a very, very obscure project barely findable via 
googling around. It's not packaged up and not available in rpmfind.net's 
vast package repo. So Andi cannot credibly claim a "oh, I thought that's 
obvious" defense.

Nor is the second (again maximally minimal) reply from Andi helpful:

   "e.g. mced"

... which still implies that "there might be others". But it does not 
tell us what _Andi_ thinks about that. A fair, honest, helpful reply 
would have been to write the truth straight away, via something like:

  " Also I should add there are other consumers of /dev/mcelog, not just
    mcelog/mce-inject. There's a tiny, still-obscure project called 
    'mced' - and there might be others although i dont know of any. 
    Granted, for our purposes, mcelog/mce-inject are the main ones to 
    care about. "

And look how such an honest and helpful reply would convey the right 
kind of technical message, instead of this multiple (and avoidable) 
ping-pong trying to spoon-feed information which still conveys a 
deceptive technical message? And that's all just because Andi apparently 
disagrees with the direction of the discussion?

This lack of basic honestly and helpfulnesss is one of the reasons why i 
have to ignore most of Andi's mails btw. Such exchanges show the attempt 
of trying to treat information as a weapon - giving it out 
conservatively while taking it in liberally and hoarding it. That's very 
much against basic FOSS principles. It is also very hard for me to trust 
a person who is willing to hurt (stand in the way of) others with such 
an ease of mind.

	Ingo
