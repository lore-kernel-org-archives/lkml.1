Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbXLCWDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbXLCWDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXLCWC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:02:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43978 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbXLCWC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:02:57 -0500
Date: Mon, 3 Dec 2007 23:02:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Markus Metzger <markus.t.metzger@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, markus.t.metzger@gmail.com
Subject: Re: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071203220255.GA10287@one.firstfloor.org>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071201074044.GA13974@elte.hu> <a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com> <200712031721.39013.ak@suse.de> <20071203164506.GA16135@elte.hu> <p73ir3fwvo2.fsf@bingen.suse.de> <20071203215524.GA9825@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203215524.GA9825@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All ptrace cleanup patches from Roland were posted by him to lkml, and 
> we picked them up from there. Review is ongoing, Roland replied to all 
> feedback with more patches, and those were integrated as well. Final 
> upstream merging of this depends on more review and test results (as 
> usual), but it's looking good so far.

Yes, clearly I overreacted. I actually saw the ptrace patches, but 
somehow didn't connect them with utrace which as I remember
was a much larger patch kit.  Sorry for that, Roland.

Anyways I think my original point about not delaying jump ptrace
for utrace holds still though. e.g. Markus' patches are a clear .25 
candidates, but for utrace that is probably far too late by now.

-Andi

