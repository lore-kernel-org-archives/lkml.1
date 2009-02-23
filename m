Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZBWK5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZBWK5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZBWK5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:57:45 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:45230 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbZBWK5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:57:45 -0500
Message-ID: <49A28110.1000802@in.ibm.com>
Date: Mon, 23 Feb 2009 16:27:20 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linuxppc-dev@ozlabs.org, linux-ext4@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
References: <49A2705D.9030008@in.ibm.com> <20090223021320.11019d64.akpm@linux-foundation.org> <18850.31567.212454.514549@cargo.ozlabs.ibm.com>
In-Reply-To: <18850.31567.212454.514549@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> It appears to have faulted on a load, implicating the source.  The
> address being referenced (0xc00000003f380000) doesn't look
> outlandish.  I wonder if this kernel has CONFIG_DEBUG_PAGEALLOC turned
> on, and what page size is selected?
Yes CONFIG_DEBUG_PAGEALLOC is enabled and the page size is 64K.

CONFIG_DEBUG_PAGEALLOC=y
CONFIG_PPC_64K_PAGES=y

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

