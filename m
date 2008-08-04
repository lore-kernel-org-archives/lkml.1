Return-Path: <linux-kernel-owner+w=401wt.eu-S1763767AbYHDVO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763767AbYHDVO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbYHDVOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:14:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:41339 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbYHDVOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BP0g0Bbxbg359X5LAQmPtauTCUPfiM609hPc40DuyV5QYghI9qbjC8rD4FHK7Euozu
         N6xRCDsxvM1kLkzqzRLEpOdAQcm/s32PyaUHxW/FMhCKEr5AczLZ+V6YxWQQZSkxqrNb
         dUsWLUnebCJdwcFHupjnmsEDXnRi+2VkoD+DA=
Message-ID: <84144f020808041414x2c1c8b82n5939b82e9a2ca99d@mail.gmail.com>
Date: Tue, 5 Aug 2008 00:14:48 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrea Arcangeli" <andrea@qumranet.com>
Subject: Re: [PATCH] workaround minor lockdep bug triggered by mm_take_all_locks
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Dave Jones" <davej@redhat.com>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan <arjan@infradead.org>
In-Reply-To: <20080804210954.GC12464@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080804145318.GA17867@redhat.com>
	 <20080804162657.GI11476@duo.random> <1217867935.3589.35.camel@twins>
	 <20080804172728.GJ11476@duo.random>
	 <20080804174659.GK11476@duo.random>
	 <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins>
	 <20080804201514.GB12464@duo.random> <1217882242.3589.90.camel@twins>
	 <20080804210954.GC12464@duo.random>
X-Google-Sender-Auth: 9abeae8a0cb41fd7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

On Mon, Aug 04, 2008 at 10:37:22PM +0200, Peter Zijlstra wrote:
>> You're so wrong it not even funny. It reports about deadlocks before
>> they happen. All it needs is to observe a lock order violation and it

On Tue, Aug 5, 2008 at 12:09 AM, Andrea Arcangeli <andrea@qumranet.com> wrote:
> Now tell me how it helps to report them... It tells me the system has
> crashed and where, it's not like I couldn't figure it out by myself
> but just noticing nothing works and all cpus are spinning in some
> spinlock slow path and pressing sysrq+t/p.

Sometimes it's hard to actually trigger a deadlock condition during
development, especially if you're not developing on a big iron
machine.
