Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbXCTPQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbXCTPQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbXCTPQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:16:22 -0400
Received: from smtp.nokia.com ([131.228.20.172]:49368 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645AbXCTPQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:16:20 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Theodore Tso <tytso@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070320135231.GA6043@thunk.org>
References: <20070318162720.GI10459@waste.org>
	 <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
	 <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron>
	 <20070320135231.GA6043@thunk.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Mar 2007 17:14:10 +0200
Message-Id: <1174403650.17249.117.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Mar 2007 15:14:10.0712 (UTC) FILETIME=[697AF180:01C76B02]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070320171420-1C862BB0-0CC1466A/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 09:52 -0400, Theodore Tso wrote:
> It would also help people understand why there are so many "units" in
> UBI, since hopefully the high-level documentation would explain why
> they fit together, and perhaps why some of the units weren't folded
> together.  What value do they add as separate components?

Teo, the units will go away. I'll leave only 4 of them:

1. I/O, just to hide some I/O related complexities.
2. Scanning: just because I am planning to add other device attaching
methods, without scanning.
3. Wear-leveling, just because I want to improve the algorithm in
future. Changing algorithm means changing data structures. So I want to
keeps them separate.
4. EBA - because I want to keep all mapping-related stuff in one place.
Well, this does not have to be called unit, just mapping-related code in
on file. Also, long-term is to have the table on-flash (currently it is
in-ram which does not scale well).

Everything else will be folded together. No itsy-bitsy. I've almost
finished this re-structuring, doing bug-fixing.

P.S.: I'll let other folks to comment the other stuff.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

