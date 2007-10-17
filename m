Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbXJQJKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbXJQJKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbXJQJKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:10:39 -0400
Received: from twin.jikos.cz ([213.151.79.26]:53822 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbXJQJKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:10:38 -0400
Date: Wed, 17 Oct 2007 11:10:23 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-mm1
In-Reply-To: <20071017160101.4dde7223.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0710171108090.18815@twin.jikos.cz>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
 <20071017160101.4dde7223.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, KAMEZAWA Hiroyuki wrote:

> I noticed 32bit binary on x86_64 behavior is changed on 2.6.23-mm1.
> This is a result of pmap after process returns -ENOMEM.(see attached program)
> == on 2.6.23 ==
[...]
>  total          4193272K
> ==
> == on 2.6.23-mm1==
[...]
>  total          2796560K
> ==
> Maybe get_unmapped_area() had some change. Is this intended ?

Hi,

hm, I guess this is probably due to pie-randomization patch, right? (could 
you please try reverting it, to see whether things get back to normal).

Oh well, this causes more trouble that I have ever imagined ... I will 
look into it, thanks a lot for the report. Andrew, please drop this one 
again, I will fix it up.

Thanks,

-- 
Jiri Kosina
