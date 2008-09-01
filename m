Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYIAInc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYIAInc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 04:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYIAInY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 04:43:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:2820 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbYIAInX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 04:43:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,306,1217833200"; 
   d="scan'208";a="331140696"
Message-ID: <48BBAB2D.3070706@linux.intel.com>
Date: Mon, 01 Sep 2008 10:43:25 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softlockup: minor cleanup, don't check task->state twice
References: <20080830170840.GA7884@tv-sign.ru>
In-Reply-To: <20080830170840.GA7884@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:

Hi Oleg,

> The recent commit 16d9679f33caf7e683471647d1472bfe133d858 changed
> check_hung_task() to filter out the TASK_KILLABLE tasks. We can
> move this check to the caller which has to test t->state anyway.

Yes makes sense to do it this way. Thanks.

-Andi
