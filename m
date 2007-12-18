Return-Path: <linux-kernel-owner+w=401wt.eu-S934477AbXLRHBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbXLRHBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbXLRHAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:00:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:23870 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466AbXLRHAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:00:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,179,1196668800"; 
   d="scan'208";a="244084830"
Message-ID: <47676FAE.30200@linux.intel.com>
Date: Mon, 17 Dec 2007 22:58:54 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org> <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com> <476703A4.7000401@linux.intel.com> <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com> <20071217154727.404e4bc4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org> <20071218023141.GM7070@thunk.org>
In-Reply-To: <20071218023141.GM7070@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Mon, Dec 17, 2007 at 04:21:12PM -0800, Linus Torvalds wrote:
>> which also gets bonus points for being totally unreadable, and thus 100% 
>> in the spirit of uuid's.
> 
> Heh.  UUID's don't have to be readable; just universally unique.  Code
> on the other hand should be readable.   :-)

Linus' suggested... improvement should either be done in all 3 places or none ;)
Since you're the maintainer... what's your suggestion?

> 
> If you want something more readable, you could print the MAC address
> and boot time.  Of course some crazy people seem to think leaking the
> MAC address will somehow be a privacy violation.  And printing a
> random UUID is a lot simpler....

boot UUID is nice in that it's different each boot, so that an oops that happens twice will have a
different UUID even if it's the same machine, while repeat-reports of the same oops will have
the same UUID. So I very much like to use some form of UUID; since the boot UUID has the
same properties I was happy to share this; if it gets too ugly or evil code wise I can always
pick something else ;-)
