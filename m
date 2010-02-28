Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0B1F7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 00:59:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:59330 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab0B1F7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 00:59:06 -0500
Message-ID: <4B8A084E.2070008@kernel.org>
Date: Sun, 28 Feb 2010 15:08:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: Re: [PATCH] workqueue: Fix build on PowerPC
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <20100227225234.GA13594@kryten>
In-Reply-To: <20100227225234.GA13594@kryten>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Feb 2010 05:57:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2010 07:52 AM, Anton Blanchard wrote:
> Fix the following compile error on PowerPC:
> 
> include/linux/workqueue.h:66: error: ‘NR_CPUS’ undeclared here (not in a function)
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Fix folded into
0028-workqueue-carry-cpu-number-in-work-data-once-executi.patch

Thanks.

-- 
tejun
