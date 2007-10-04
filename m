Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbXJDVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbXJDVL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759244AbXJDVLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:11:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36441
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760479AbXJDVLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:11:14 -0400
Date: Thu, 04 Oct 2007 14:11:13 -0700 (PDT)
Message-Id: <20071004.141113.08322956.davem@davemloft.net>
To: cebbert@redhat.com
Cc: willy@linux.intel.com, clameter@sgi.com, nickpiggin@yahoo.com.au,
       hch@lst.de, mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com, jens.axboe@oracle.com,
       suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
From: David Miller <davem@davemloft.net>
In-Reply-To: <470554D9.2050505@redhat.com>
References: <20071004192824.GA9852@linux.intel.com>
	<20071004.135537.39158051.davem@davemloft.net>
	<470554D9.2050505@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>
Date: Thu, 04 Oct 2007 17:02:17 -0400

> How do you simulate reading 100TB of data spread across 3000 disks,
> selecting 10% of it using some criterion, then sorting and
> summarizing the result?

You repeatedly read zeros from a smaller disk into the same amount of
memory, and sort that as if it were real data instead.

You're not thinking outside of the box, and you need to do that to
write good test cases and fix kernel bugs effectively.
