Return-Path: <linux-kernel-owner+w=401wt.eu-S932610AbXBZWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbXBZWhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932626AbXBZWhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:37:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620AbXBZWhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:37:45 -0500
Date: Mon, 26 Feb 2007 17:36:45 -0500
From: Dave Jones <davej@redhat.com>
To: Pete Harlan <harlan@artselect.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
Message-ID: <20070226223645.GA24174@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pete Harlan <harlan@artselect.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Rik van Riel <riel@redhat.com>,
	Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Jens Axboe <jens.axboe@oracle.com>
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070226220401.GA22363@artselect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226220401.GA22363@artselect.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 04:04:01PM -0600, Pete Harlan wrote:
 > On Tue, Feb 27, 2007 at 12:36:04AM +1100, Nick Piggin wrote:
 > > I found a couple of interesting issues so far. Firstly, the MySQL
 > > version that I'm using (5.0.26-Max) is making lots of calls to
 > 
 > FYI, MySQL fixed some scalability problems in version 5.0.30, as
 > mentioned here:
 > 
 > http://www.mysqlperformanceblog.com/2007/01/03/innodb-benchmarks/
 > 
 > It may be worth using more recent sources than 5.0.26 if tracking down
 > scaling problems in MySQL.

The blog post that originated this discussion ran tests on 5.0.33
Not that the mysql version should really matter. The key point here
is that FreeBSD and Linux were running the *same* version, and
FreeBSD was able to handle the situation better somehow.

		Dave

-- 
http://www.codemonkey.org.uk
