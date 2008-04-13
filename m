Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYDMSY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYDMSY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYDMSYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:24:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34825 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbYDMSYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:24:19 -0400
Date: Sun, 13 Apr 2008 20:29:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [rfc] hw resource debugging checks
Message-ID: <20080413182910.GB8641@one.firstfloor.org>
References: <200804102159.14563.rjw@sisk.pl> <20080410203800.GA14560@elte.hu> <200804110028.22290.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl> <20080413075845.GJ20332@elte.hu> <87d4ouw0u9.fsf@basil.nowhere.org> <86802c440804131119m1c43497bg1864ce9751438e85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804131119m1c43497bg1864ce9751438e85@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> even I could talk to BIOS
> engineers everyday and tell them how to fix the problem in BIOS,  some
> still can not be fixed because of the legacy BIOS framework or big
> mess.

... so you opt to create the big mess in the kernel. Great.

And it does not even fixes a real problem, but getting
mmconfig or the numa bus discovery to work is not really a too serious 
issue anyways. At best it is the icing on the cake to enable
some relatively obscure functionality and be a little more
efficient, but nothing really fundamental.

But for those things just expecting a working modern BIOS is quite
reasonable.

-Andi
