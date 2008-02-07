Return-Path: <linux-kernel-owner+w=401wt.eu-S1762436AbYBGUkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762436AbYBGUkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbYBGUj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:39:57 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:23862 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbYBGUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:39:57 -0500
Message-ID: <47AB6CA0.1040108@hp.com>
Date: Thu, 07 Feb 2008 15:40:00 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, dgc@sgi.com,
       npiggin@suse.de
Subject: Re: IO queuing and complete affinity with threads (was Re: [PATCH
 0/8] IO queuing and complete affinity)
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <20080207182544.GM15220@kernel.dk>
In-Reply-To: <20080207182544.GM15220@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Hi,
> 
> Here's a variant using kernel threads only, the nasty arch bits are then
> not needed. Works for me, no performance testing (that's a hint for Alan
> to try and queue up some testing for this variant as well :-)
> 
> 
I'll get to that, working my way through the first batch of testing on a NUMA platform. [[If anybody has ideas on specific testing to do, that would be helpful.]] I do plan on running some AIM7 tests, as those have shown improvement in other types of affinity changes in the kernel, and some of them have "interesting" IO load characteristics.

Alan

