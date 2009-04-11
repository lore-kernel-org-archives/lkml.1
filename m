Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZDKBqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZDKBqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 21:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbZDKBp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 21:45:57 -0400
Received: from mga10.intel.com ([192.55.52.92]:26046 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754310AbZDKBp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 21:45:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,171,1239001200"; 
   d="scan'208";a="680653096"
Message-ID: <49DFF651.5080909@linux.intel.com>
Date: Fri, 10 Apr 2009 18:45:53 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@suse.com>, linux-pm@lists.linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
References: <200904100057.43827.rjw@sisk.pl> <200904102058.36018.rjw@sisk.pl> <alpine.LFD.2.00.0904101204350.4583@localhost.localdomain> <200904110206.33525.rjw@suse.com> <alpine.LFD.2.00.0904101817100.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904101817100.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Hmm.
> 
> I'm not 100% sure that patch is good.
> 
> The reason? I think it's going to deadlock if an async caller ends up 
> wanting to load a module, because then the nestecd 
> "async_synchronize_full()" will basically want to wait for itself.
> 
> So it's a good test-patch, and maybe no async caller ever loads a module, 
> but it makes me a bit nervous.
> 
> But the fact that it fixes things for you at least means that the _reason_ 
> for the problem is know, and maybe there are alternative solutions. Arjan?

I just got back from the LF summit and am catching up on mail; I'll take a look
at the history.
