Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936197Ab0BZMf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:35:28 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:44440 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936111Ab0BZMf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:35:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SeT/ifxbCbE7lsDHVR7GWrI8nQkLR9k7G5cySDRDhQU0FjoyV5PqvDnZXYck9gOmC2
         /x4sBwyzUIY0msXAI5JA/L/GvMPWgcr87jVjRoOsTQGBynFgGA72QqR/LLck8hFqWeEj
         CN5/B1mknNwM4HJPhvXmSUL7hLxRlpimOUta0=
MIME-Version: 1.0
In-Reply-To: <20100226114312.GB16335@basil.fritz.box>
References: <20100215110135.GN5723@laptop>
	 <20100220090154.GB11287@basil.fritz.box>
	 <alpine.DEB.2.00.1002240949140.26771@router.home>
	 <4B862623.5090608@cs.helsinki.fi>
	 <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1002251228140.18861@router.home>
	 <alpine.DEB.2.00.1002251315010.3501@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1002251627040.18861@router.home>
	 <4B87A62E.5030307@cs.helsinki.fi>
	 <20100226114312.GB16335@basil.fritz.box>
Date: Fri, 26 Feb 2010 14:35:24 +0200
X-Google-Sender-Auth: 90dd072724e6194c
Message-ID: <84144f021002260435l6de50c0enb3fcc0c8b45d9f20@mail.gmail.com>
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 1:43 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Fri, Feb 26, 2010 at 12:45:02PM +0200, Pekka Enberg wrote:
>> Christoph Lameter kirjoitti:
>>>> kmalloc_node() in generic kernel code.  All that is done under
>>>> MEM_GOING_ONLINE and not MEM_ONLINE, which is why I suggest the first and
>>>> fourth patch in this series may not be necessary if we prevent setting the
>>>> bit in the nodemask or building the zonelists until the slab nodelists are
>>>> ready.
>>>
>>> That sounds good.
>>
>> Andi?
>
> Well if Christoph wants to submit a better patch that is tested and solves
> the problems he can do that.

Sure.

> if he doesn't then I think my patch kit which has been tested
> is the best alternative currently.

So do you expect me to merge your patches over his objections?

                         Pekka
