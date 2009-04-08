Return-Path: <linux-kernel-owner+w=401wt.eu-S1763839AbZDHUqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763839AbZDHUqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbZDHUqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:46:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39211 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbZDHUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:45:59 -0400
X-Sasl-enc: 0/haD2XxSDaxND/vjFj1quLPDYTjygaF6ofdD8i4EJAI 1239223557
Message-ID: <49DD0D02.3030604@fastmail.fm>
Date: Wed, 08 Apr 2009 21:45:54 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
References: <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com> <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu> <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu> <49DCB8C5.4090108@fastmail.fm> <20090408144842.GK12931@elte.hu> <49DCBA61.8060507@fastmail.fm> <20090408145715.GO12931@elte.hu> <49DCBBDF.4040603@fastmail.fm> <20090408151644.GQ12931@elte.hu>
In-Reply-To: <20090408151644.GQ12931@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> In theory we could put regex patterns into MAINTAINERS. Something 
> like this:
>
> LOCKDEP AND LOCKSTAT
> P:	Peter Zijlstra
> M:	peterz@infradead.org
> P:	Ingo Molnar
> M:	mingo@redhat.com
> L:	linux-kernel@vger.kernel.org
> T:	git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
> F:	kernel/lock*
> F:	include/linux/lockdep.h
> S:	Maintained
>
> Note: there are files that fall under multiple maintainers so this 
> wouldnt be a 'precise' thing - but it would sure be useful.
>
> ( There's also other details like subdirectories within a larger 
>   hiearchy and there being overlap between problems. Sometimes they 
>   are sub-maintained, sometimes they are exclusive so pure glob
>   patterns are probably not enough. )
>
> If this concept looks good to you ... i'd suggest that before you do 
> a large patch against MAINTAINERS mapping all the maintainer 
> domains, could you just do it for a few cases and send an RFC patch 
> to lkml?
>
> If there's a general upstream buy-in and a there's a 
> scripts/list-maintainers.sh script that takes advantage of it then 
> all this would be rather useful. (and i've Cc:-ed Andrew and Linus - 
> if this is to be shot down due to fundamental objections then better 
> do it at the early stages ;-)
>
> Plus checkpatch could be extended to check whether the Cc: list in a 
> patch properly matches the patterns in MAINTAINERS.
>
> If done propery this would save us from quite a few mechanic "hm, 
> who maintains _that_ file??" searches and it would also save 
> maintainers from quite a few "hm, who queued up _that_ crap without 
> Cc:-ing me??" moments.
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
That has already been done. Someone just so happened to submit
such a patch today.

http://marc.info/?l=linux-kernel&m=123916809504492&w=2

Thanks,

Jack


