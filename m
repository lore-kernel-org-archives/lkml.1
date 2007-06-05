Return-Path: <linux-kernel-owner+w=401wt.eu-S1763698AbXFEI50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763698AbXFEI50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761928AbXFEI5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:57:19 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:35107 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761905AbXFEI5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:57:18 -0400
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
From: Richard Purdie <rpurdie@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <nitingupta910@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Daniel Hazelton <dhazelton@enter.net>,
       LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070604225038.9973226b.akpm@linux-foundation.org>
References: <1180971378.6313.72.camel@localhost.localdomain>
	 <200706041214.38017.dhazelton@enter.net>
	 <1180975976.6313.133.camel@localhost.localdomain>
	 <4cefeab80706041126y5f12402cl61b72ec101dd7915@mail.gmail.com>
	 <20070604200606.GA5500@stusta.de>
	 <4cefeab80706042230u1fc7f485j30cea371d1d3117a@mail.gmail.com>
	 <20070604225038.9973226b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 09:56:42 +0100
Message-Id: <1181033802.6180.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 22:50 -0700, Andrew Morton wrote:
> I'd say go with the cleanups.  The code I've seen is going to be quite
> unmaintainable by any kernel developer.
> 
> Any fixes which come from upstream can be trivially applied by taking the
> diffs against the version of upstream we started with and manually applying
> them to our version.  If the diffs are too large and complex for that then
> a) we shouldn't be merging the code in its current state anyway and b) with
> the code as-is we couldn't effectively review or changelog those diffs, so
> we shouldn't apply them.
> 
> So just fork it and freeze it.

Ok, thanks for the decision.

Since I don't have too much faith in what Nitin has done with it, I'll
produce a version myself. In theory we should end up with identical code
so will be a sanity check of Nitin's code if nothing else.

Cheers,

Richard


