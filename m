Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZIQLnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZIQLnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZIQLnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:43:37 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34409 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZIQLng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VDIYyP0i4WJtzYEOrbO7sFl2bzsIAxDTFFMIh+acT5xWodNF5vsocD1NNnqH+UFfAg
         K1aWEidFnLvKj8dk9ncPbFnZyJ6oZm2JPdp+OB2Mw8m+JX5O02Cq7u+quv2b1LaNfCP1
         3p/+xbAib6eRnXKnvZWfgelqIAeHJFK6zAuNQ=
MIME-Version: 1.0
In-Reply-To: <20090917113837.GK18404@wotan.suse.de>
References: <1253083059.5478.1.camel@penberg-laptop>
	 <20090917100841.GF13002@csn.ul.ie>
	 <1253183365.4975.20.camel@penberg-laptop>
	 <20090917105707.GA7205@csn.ul.ie> <4AB21C3D.2080202@in.ibm.com>
	 <20090917113837.GK18404@wotan.suse.de>
Date: Thu, 17 Sep 2009 14:43:38 +0300
X-Google-Sender-Auth: d78882fe97b7c1ba
Message-ID: <84144f020909170443y5f8c3c8fo7d2a4163e636f368@mail.gmail.com>
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Sachin Sant <sachinp@in.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Mel Gorman wrote:
>> >I have access to a ppc machine but not necessarily one with a memoryless
>> >nodes
>> >that can reproduce this problem.
>> >
>> >Assuming Sachin is the reporter and we are in the same company, maybe I
>> >have access to the machine. Sachin, can you mail me privately what this
>> >machine is called and lets see can I get some time on that machine? By
>> >any chance, was this bisected or did it just show up when SLQB became
>> >the default?

On Thu, Sep 17, 2009 at 04:53:41PM +0530, Sachin Sant wrote:
>> Have sent you the access details for the machine. This bug showed
>> up when SLQB was enabled as default in linux-next

On Thu, Sep 17, 2009 at 2:38 PM, Nick Piggin <npiggin@suse.de> wrote:
> Maybe it will be better to hold off merging until this is
> debugged then? If it is merged as a non-default option, then
> I can't see it being a huge issue to merge it a bit after the
> window? It doesn't touch anything else...

Me sending anything but bug fixes to Linus after the merge window is
closed...? That's one scary thought!

But yeah, I can hold the pull request until the issue is resolved. If
Linus doesn't want to merge SLQB for 2.6.32, we'll just try again for
2.6.33.

                        Pekka
