Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbXLRSrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbXLRSrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbXLRSrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:47:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbXLRSrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:47:09 -0500
Date: Tue, 18 Dec 2007 10:45:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
cc: Arjan van de Ven <arjan@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
In-Reply-To: <20071218182808.GV7070@thunk.org>
Message-ID: <alpine.LFD.0.9999.0712181045110.21557@woody.linux-foundation.org>
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org> <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com> <476703A4.7000401@linux.intel.com> <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com>
 <20071217154727.404e4bc4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org> <20071218023141.GM7070@thunk.org> <47676FAE.30200@linux.intel.com> <20071218182808.GV7070@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Dec 2007, Theodore Tso wrote:
> 
> Well, Matt took over maintenance of the /dev/random driver, but my
> take on it is that code readability is more important that saving a
> few bytes of generated code or speed; the code paths are only executed
> once, so it's hardly a fast path.

Quite frankly, I'd argue that while my suggested code wasn't exactly 
readable, it was more so than the horror it tried to replace.

BAD CODE is never readable. At least my suggestion was good code.

			Linus
