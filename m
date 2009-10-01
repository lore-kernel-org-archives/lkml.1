Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZJAQbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZJAQbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZJAQby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:31:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:37160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbZJAQby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:31:54 -0400
Message-ID: <4AC4D93C.4030703@kernel.org>
Date: Fri, 02 Oct 2009 01:30:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Jeff Garzik <jeff@garzik.org>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com
Subject: Re: [PATCH 10/19] workqueue: update cwq alignement and make one more
 flag bit available
References: <4AC4D595.2070202@garzik.org> <1254384558-1018-11-git-send-email-tj@kernel.org> <1254384558-1018-1-git-send-email-tj@kernel.org> <10133.1254402320@redhat.com> <15216.1254414054@redhat.com>
In-Reply-To: <15216.1254414054@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 16:30:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> The quoted code is a standard kernel technique for creating typed constants
>> that are visible to the C compiler (rather than CPP) and debugger.
>>
>> It is found in a great many Linux kernel drivers at this point, and is
>> definitely not abuse, IMO.
> 
> Just because it's common practice, and just because you like it, doesn't make
> it not abuse.  But that's a side issue, and fairly irrelevant to the actual
> implementation.

Yeap, that's something I picked up from Jeff while working on libata
and I'm quite fond of it.  I haven't encountered any downside of it
yet.  Any reason why you think it's an abuse?  But, at any rate, yeap,
it's a pretty peripheral issue.

Thanks.

-- 
tejun
