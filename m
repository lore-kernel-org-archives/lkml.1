Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab0BPDzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 22:55:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:45948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547Ab0BPDzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 22:55:32 -0500
Message-ID: <4B7A1817.4050204@kernel.org>
Date: Tue, 16 Feb 2010 12:59:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 35/40] fscache: convert object to use workqueue instead
 of slow-work
References: <4B763C17.5080707@kernel.org> <1263776272-382-36-git-send-email-tj@kernel.org> <1263776272-382-1-git-send-email-tj@kernel.org> <24913.1265997809@redhat.com> <27102.1266246296@redhat.com> <4B7A13C6.4060402@kernel.org>
In-Reply-To: <4B7A13C6.4060402@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Feb 2010 03:51:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

BTW, if we solve the yielding problem (I think we can retain the
original behavior by implementing it inside fscache) and the
reentrance issue, do you see any other obstacles in switching to cmwq?

Thanks.

-- 
tejun
