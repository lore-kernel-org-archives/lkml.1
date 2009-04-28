Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZD1VwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZD1VwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758591AbZD1VwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:52:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:57290 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717AbZD1VwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:52:07 -0400
Date: Tue, 28 Apr 2009 14:50:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Florian Mickler <florian@mickler.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
In-Reply-To: <20090428234300.4a49d22f@schatten>
Message-ID: <alpine.DEB.1.10.0904281447240.17268@asgard.lang.hm>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com> <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org> <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
 <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm> <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain> <alpine.DEB.1.10.0904281019580.17268@asgard.lang.hm> <alpine.LFD.2.00.0904281043420.22156@localhost.localdomain>
 <20090428234300.4a49d22f@schatten>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Florian Mickler wrote:

> On Tue, 28 Apr 2009 10:50:14 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>>
>>
>> On Tue, 28 Apr 2009, david@lang.hm wrote:
>
>>> I've seen people talk about creating such tools, but the responses
>>> that I've seen have tended to discourage them.
>>
>> I suspect that they'd generally end up handling the easy cases, and
>> seldom anything more. At which point they're not all that useful.
>>
>> 		Linus
>
> perhaps there needs to be an infrastructure where each
> kconfig-entry-causer can also provide userlevel code to help with that
> entry?
>
> i could imagine a kconfig knob to specify an optional
> per-kconfig-userspace-helperscript which calculates a new "suggested
> value" at configure time.
> this "suggested value" is displayed next to the default value
> or is then already incorporated in the default value.

what is the difference between the default value and this suggested value?

> each maintainer of each kconfig entry
> a) decides if it is possible to supply such a script
> b) if it would be useful
> c) suplies and maintains his (focused on only one kconfig entry) script

please no!!! we don't want to have to run 2000 different scripts to get 
the settings.

one script.

David Lang

> c) if the script is 100% fool-proof he can say so in the description of
> the kconfig-entry or just skip the user or notify the user of the
> result.
> d) maybe dosn't provide an userspace helper
>
> this spreads the burden of the complex detection-code and hopefully
> eases configuration for everyone where possible.
>
> what do others think?
>
>
> sincerely,
> Florian
>
