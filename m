Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZDNOfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZDNOfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZDNOfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:35:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59272 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZDNOfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:35:19 -0400
Date: Tue, 14 Apr 2009 16:32:52 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
Message-ID: <20090414143252.GE28265@random.random>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <2f11576a0904140639l426e137ewdc46296cdb377dd@mail.gmail.com> <20090414141209.GB31644@random.random> <200904150026.36142.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904150026.36142.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 12:26:34AM +1000, Nick Piggin wrote:
> Andrea: I didn't veto that set_bit change of yours as such. I just

I know you didn't ;)

> noted there could be more atomic operations. Actually I would
> welcome more comparison between our two approaches, but they seem

Agree about the welcome of comparison, it'd be nice to measure it the
enterprise workloads that showed the gup_fast gain in the first place.
