Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbZICSGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbZICSGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZICSGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:06:39 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:37127 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZICSGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=wx9YAZajKjcW42p2szGoT+CMNXqmNOMgBdCgRO0RUMXOjNhFvH1H3dAu9I/vhQYB21
         rvRgzBhzEKywLld1sIhn8X17NLiQc3ZYAMffx7q+A2KDeAFlIGDuQt/wlnr8eu1cC2hi
         tHW1iZeX/8IjopOV2kSt3oCOtIim5BUY8FM0I=
MIME-Version: 1.0
In-Reply-To: <1252001060.9336.0.camel@johannes.local>
References: <43e72e890909021729q7c40f907v7a81eaf5c8b73a61@mail.gmail.com> 
	<84144f020909022323na828156v4eb9a8497cadaef8@mail.gmail.com> 
	<1251983939.22485.18.camel@pc1117.cambridge.arm.com> <1251984845.3336.25.camel@johannes.local> 
	<43e72e890909031100l5f28dd4cu30cf1e1c735e0e9d@mail.gmail.com> 
	<1252001060.9336.0.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Sep 2009 11:06:18 -0700
Message-ID: <43e72e890909031106q1dc3ebf0nb5281e2aeddd215e@mail.gmail.com>
Subject: Re: Exporting kmemleak.h to userspace
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 11:04 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-09-03 at 11:00 -0700, Luis R. Rodriguez wrote:
>
>> Anyway my point was that userspace does not need kmemleak.h and we are
>> providing it to userspace.
>
> No, we're not providing it to userspace.
>
> If you actually build userspace headers it won't be included.

Ah then I completely mispoke. Ignore this then.

How *do* you export headers through kbuild then?

  Luis
