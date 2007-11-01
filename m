Return-Path: <linux-kernel-owner+w=401wt.eu-S1759648AbXKALYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbXKALYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 07:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbXKALYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 07:24:14 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:51817 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbXKALYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 07:24:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAIdUKUdMQWvU/2dsb2JhbACBW45W
Date: Thu, 1 Nov 2007 07:24:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH] markers: modpost
Message-ID: <20071101112407.GA24217@Krystal>
References: <20070921133006.GF8964@redhat.com> <20070921133820.GD13129@Krystal> <20071015194120.GA22562@redhat.com> <20071015231209.GA18994@Krystal> <20071015235033.321E84D0389@magilla.localdomain> <20071025191722.GA6114@Krystal> <20071026142810.GA14814@redhat.com> <20071101010624.54D8D4D04AE@magilla.localdomain> <20071101024622.GA3343@Krystal> <20071101093725.891F34D04AE@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071101093725.891F34D04AE@magilla.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:20:39 up 94 days, 11:39,  2 users,  load average: 1.41, 1.33, 0.94
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland McGrath (roland@redhat.com) wrote:
> > If we want to do it safely, I think we should iterate from
> > __start___markers to __stop___markers symbols of vmlinux and get the
> > pointers to the name/format string pairs.
> > 
> > The same can then be done with modules using the __markers section.
> > 
> > Or maybe is there some reason not to do that ?
> 
> It's just rather a pain in the ass, a whole lot more fiddly work.
> cf "somewhat crude" and "foreseeable future" in my patch's log entry.
> Knock yourself out if you're looking for more tedious hacking to do in
> modpost.c, but I say fix it when it breaks.
> 

Hmmmm, I have rarely seen code go into mainline without addressing valid
technical criticism first. Please fix.

I'll look into it if I find the time.

Mathieu

> 
> Thanks,
> Roland

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
