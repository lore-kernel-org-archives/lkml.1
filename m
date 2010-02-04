Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0BDMgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 07:36:00 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:63002 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab0BDMf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 07:35:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZbOXRqAdmXcnH6q9LRNVTf15padqycV4zMaynKFQpOMZ0bvK42Grijb4Bdij2dDJQx
         V7en/gmi0YuJpTYIYAc75aZUNplLdfHXt6RT5yymJ6YtmmisiTb/suisUrPCesN19gex
         H9wbqXBcaFGK/XO0UMRfJ8Cp4vXE69pAoUOGE=
MIME-Version: 1.0
In-Reply-To: <4B6ABDEF.8090005@trash.net>
References: <1265108690.2861.118.camel@tonnant>
	 <1265134598.2861.191.camel@tonnant> <4B6870AF.6060109@trash.net>
	 <4B6967BC.600@trash.net> <1265222289.2861.290.camel@tonnant>
	 <20100203190948.GA5182@x200> <1265226227.2861.302.camel@tonnant>
	 <4B6ABCB8.4080904@trash.net>
	 <b6fcc0a1002040427n221da433n755350b4a41bbf9b@mail.gmail.com>
	 <4B6ABDEF.8090005@trash.net>
Date: Thu, 4 Feb 2010 14:35:56 +0200
Message-ID: <b6fcc0a1002040435t150aa7axf2dc0b139ed8f258@mail.gmail.com>
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Jon Masters <jonathan@jonmasters.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 2:30 PM, Patrick McHardy <kaber@trash.net> wrote:
> Alexey Dobriyan wrote:
>> On Thu, Feb 4, 2010 at 2:25 PM, Patrick McHardy <kaber@trash.net> wrote:
>>> Jon Masters wrote:
>>>> On Wed, 2010-02-03 at 21:09 +0200, Alexey Dobriyan wrote:
>>>>> On Wed, Feb 03, 2010 at 01:38:09PM -0500, Jon Masters wrote:
>>>>>> *). Per namespace cacheing allocation (the cachep bits). We know it's
>>>>>> still possible for weirdness to happen in the SLAB cache here.
>>>>> Tiny race, needs reproducer.
>>>> Maybe. I think it's worth fixing anyway.
>>> Absolutely, I'll also apply Eric's patch with the %p fix for the
>>> slab name.
>>
>> This would show kernel pointers in userspace ;-)
>> So, net->id is required.
>
> I don't see the problem. But yes, it would be nicer to have an ID.

This is done (or rather, not done) to not show attackers
where data structures are.
