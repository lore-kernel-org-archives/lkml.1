Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXCUIwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXCUIwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXCUIwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:52:05 -0400
Received: from smtp.nokia.com ([131.228.20.172]:37527 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXCUIwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:52:04 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Theodore Tso <tytso@mit.edu>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070320220312.GC29493@thunk.org>
References: <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
	 <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron>
	 <20070320135231.GA6043@thunk.org>
	 <1174406395.30079.139.camel@zod.rchland.ibm.com>
	 <20070320220312.GC29493@thunk.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 21 Mar 2007 10:44:35 +0200
Message-Id: <1174466675.17249.182.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 21 Mar 2007 08:44:35.0741 (UTC) FILETIME=[27532CD0:01C76B95]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 18:03 -0400, Theodore Tso wrote:
> So this is probably a stupid question, but what drives the design
> decision to store the metadata in-band instead of out-of-band (and you
> don't have to answer me here; putting it in the overall system
> architecture document is just as good, and probably better.  :-)

Because
a. Many flashes have no out-of-band. We want to support them as well
b. Modern MLC NAND flashes use _whole_ OOB for ECC and this is the
modern trend.

I will update FAQ and add this there later.

> As I mentioned to you in IRC, in the future if there is pending
> changes in response to reviewer comments, it might be a good idea to
> mention that, so that reviewers know not make those comments again, or
> worry that the comments had been ignored.

Teo, I wrote you 2 times that your point was understood and this would
be fixed. You should not think your comments are ignored because they
are not.
 
> Well, having spent some time looking at the FAQ's and all of the
> comments kernel docs embedded in the header files and source files,
> there are sections that I would move to an overall system architecture
> documentation, but there is still a lot that was missing that makes it
> hard to review the patches.  I'm sure a lot of it is my own ignorance,
> but that's probably one of the challenges with the UBI layer; not as
> more people have a basic background in say say scheduling or VM or
> filesystem than there are people who have a basic background in flash
> devices.

Docs and FAQ will be improved, this is a question of time.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

