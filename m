Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYGPMuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYGPMuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbYGPMum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:50:42 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:4423 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbYGPMul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sFBG+tN/s6OffxXbaZO05YFxC221/eCP8YDjVQph98yRm+OZRXmuzba+gSUg9HYPHg
         bTX7LPmInOJ5fb8w1oIWjm1zvyJII4ipo9m/MC2nX9PfeKC/wT8vzRt9ztZLCMQYKAWm
         5wdJv3yAR8iXgPpO+/gh0ARU93/0vmTumtvtg=
Message-ID: <19f34abd0807160550v68aacb58nbdd46b0fe74c4704@mail.gmail.com>
Date: Wed, 16 Jul 2008 14:50:39 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: more header fixes
Cc: linux-kernel@vger.kernel.org, "the arch/x86 maintainers" <x86@kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080716115137.GA8075@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610214544.GA14824@damson.getinternet.no>
	 <20080618103006.GF15255@elte.hu>
	 <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com>
	 <20080626120202.GH29619@elte.hu>
	 <19f34abd0806260953h504ff85dmf11a59171df3442b@mail.gmail.com>
	 <20080701092820.GA31309@elte.hu> <20080716115137.GA8075@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 1:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>
>> > > or perhaps we could include it in tip/master right now as well, if
>> > > you did another branch that excluded the files below. That would
>> > > make merging a lot easier - and we could do a second phase in
>> > > v2.6.27-rc1. Hm?
>> >
>> > I don't think we really need to resolve conflicts at all. What we
>> > can do is simply to re-run the scripts against tip/master whenever
>> > you want the update.
>>
>> ok, lets do it that way.
>
> ... the right moment for this would be about now. Mind rerunning your
> scripts and create a pullable linux-2.6-headers tree, based on latest
> -git?

Aright! Here she is; you may pull the 'for-tip' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-2.6-headers.git
for-tip

To see the result. This was based on tip/master. Shortlog:

Vegard Nossum (3):
      x86: consolidate header guards
      kvm: fix spurious '#' in header
      kvm: consolidate header guard


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
