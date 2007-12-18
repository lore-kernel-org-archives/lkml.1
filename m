Return-Path: <linux-kernel-owner+w=401wt.eu-S1765005AbXLRS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765005AbXLRS22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbXLRS2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:28:17 -0500
Received: from thunk.org ([69.25.196.29]:42962 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbXLRS2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:28:17 -0500
Date: Tue, 18 Dec 2007 13:28:08 -0500
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
Message-ID: <20071218182808.GV7070@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, protasnb@gmail.com
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org> <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com> <476703A4.7000401@linux.intel.com> <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com> <20071217154727.404e4bc4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org> <20071218023141.GM7070@thunk.org> <47676FAE.30200@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47676FAE.30200@linux.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 10:58:54PM -0800, Arjan van de Ven wrote:
> Theodore Tso wrote:
>> On Mon, Dec 17, 2007 at 04:21:12PM -0800, Linus Torvalds wrote:
>>> which also gets bonus points for being totally unreadable, and thus 100% 
>>> in the spirit of uuid's.
>> Heh.  UUID's don't have to be readable; just universally unique.  Code
>> on the other hand should be readable.   :-)
>
> Linus' suggested... improvement should either be done in all 3 places or 
> none ;)
> Since you're the maintainer... what's your suggestion?

Well, Matt took over maintenance of the /dev/random driver, but my
take on it is that code readability is more important that saving a
few bytes of generated code or speed; the code paths are only executed
once, so it's hardly a fast path.

      	      				- Ted
