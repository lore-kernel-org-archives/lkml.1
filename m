Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYKUL6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYKUL6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYKUL6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:58:31 -0500
Received: from styx.suse.cz ([82.119.242.94]:38341 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752737AbYKUL6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:58:31 -0500
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after swap_cluster_max pages
Date: Fri, 21 Nov 2008 12:59:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20081113171208.6985638e@bree.surriel.com> <20081119165443.GB26749@csn.ul.ie>
In-Reply-To: <20081119165443.GB26749@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811211259.30760.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Wednesday 19 of November 2008 17:54:44 Mel Gorman napsal(a):
>[...]
> I was going to ask if it was easier to go OOM now, but even under very high
> stress, we should be making forward progress. It's just in smaller steps so
> I can't see it causing a problem.

Actually, I had to apply a very similar patch the other day to reduce the time 
the system was unresponsive because of the OOM-killer, so I tested OOM 
situations quite a lot, and it did not cause any problem.

Petr Tesarik
