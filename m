Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbZICN2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbZICN2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZICN2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:28:31 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42145 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZICN2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s+JqY7NNGQK3Kwxam5JOyGWyOu/QuZ/KCntEUcO7bfJXkOyhmV0Ab8rsOVOPsrA4Jr
         CZ0pKSfdkvz6zt9aWrYD+0TUfNGFLiD8WE1SmnZqR7O29+ech8vbeMzImlgjZUxmadHM
         QL7+W+tYoFtSTqQhaBq/bysJgc7ukdUodRN/c=
MIME-Version: 1.0
In-Reply-To: <4A9F1620.2080105@gmail.com>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>
	 <alpine.DEB.1.10.0908121820410.3257@gentwo.org>
	 <c4e36d110908131009l78b29bffvb4d41b90f9b83288@mail.gmail.com>
	 <c4e36d110908140233v59421ba6y82192b858210370d@mail.gmail.com>
	 <4A87CE60.4020506@gmail.com> <4A896324.3040104@trash.net>
	 <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com>
	 <4A9EEF07.5070800@gmail.com>
	 <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>
	 <4A9F1620.2080105@gmail.com>
Date: Thu, 3 Sep 2009 15:28:30 +0200
Message-ID: <c4e36d110909030628j53cc0abfq6c1eef7e5e97565b@mail.gmail.com>
Subject: Re: [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>,
       Christoph Lameter <cl@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/3 Eric Dumazet <eric.dumazet@gmail.com>:
> Zdenek Kabelac a écrit :
>>
>> Well I'm not noticing any ill behavior - also note - rcu_barrier() is
>> there before the cache is destroyed.
>> But as I said - it's just my shot into the dark - which seems to work for me...
>>
>
> Reading again your traces, I do believe there are two bugs in slub
>
> Maybe not explaining your problem, but worth to fix !
>
> Thank you
>
> [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
>


Ok - I can confirm that this patch fixes my reboot problem.

Thanks

Zdenek
