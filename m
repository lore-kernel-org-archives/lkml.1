Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbXLRKMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbXLRKMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbXLRKMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:12:10 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:60859 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXLRKMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:12:08 -0500
Subject: Re: Top kernel oopses/warnings this week
From: Jon Masters <jonathan@jonmasters.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com
In-Reply-To: <20071218023141.GM7070@thunk.org>
References: <4762CF8C.90808@linux.intel.com>
	 <20071217172331.GA23070@elte.hu>
	 <20071217133631.5bbc5842@laptopd505.fenrus.org>
	 <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com>
	 <476703A4.7000401@linux.intel.com>
	 <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com>
	 <20071217154727.404e4bc4@laptopd505.fenrus.org>
	 <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org>
	 <20071218023141.GM7070@thunk.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 18 Dec 2007 05:11:15 -0500
Message-Id: <1197972675.31899.15.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-17 at 21:31 -0500, Theodore Tso wrote:
> On Mon, Dec 17, 2007 at 04:21:12PM -0800, Linus Torvalds wrote:
> > which also gets bonus points for being totally unreadable, and thus 100% 
> > in the spirit of uuid's.
> 
> Heh.  UUID's don't have to be readable; just universally unique.  Code
> on the other hand should be readable.   :-)
> 
> If you want something more readable, you could print the MAC address
> and boot time.  Of course some crazy people seem to think leaking the
> MAC address will somehow be a privacy violation.  And printing a
> random UUID is a lot simpler....

Printing a random UUID is necessary, for now anyway, because you cannot
assume every machine is going to have a MAC address, even if it is
deemed appropriate to print this on oops.

The Network is the Computer!

Jon.


