Return-Path: <linux-kernel-owner+w=401wt.eu-S1161238AbXBZWEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161238AbXBZWEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161255AbXBZWEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:04:11 -0500
Received: from peacekeeper.artselect.com ([69.18.47.2]:41771 "EHLO
	wyeth.artselect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161238AbXBZWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:04:10 -0500
Date: Mon, 26 Feb 2007 16:04:01 -0600
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rik van Riel <riel@redhat.com>, Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
Message-ID: <20070226220401.GA22363@artselect.com>
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E2E244.8040009@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Pete Harlan <harlan@artselect.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 12:36:04AM +1100, Nick Piggin wrote:
> I found a couple of interesting issues so far. Firstly, the MySQL
> version that I'm using (5.0.26-Max) is making lots of calls to

FYI, MySQL fixed some scalability problems in version 5.0.30, as
mentioned here:

http://www.mysqlperformanceblog.com/2007/01/03/innodb-benchmarks/

It may be worth using more recent sources than 5.0.26 if tracking down
scaling problems in MySQL.

--Pete

----------------------------------
Pete Harlan
ArtSelect, Inc.
harlan@artselect.com
http://www.artselect.com
ArtSelect is a subsidiary of a21, Inc.
