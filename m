Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZLWGNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZLWGNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 01:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZLWGNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 01:13:33 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:56771 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZLWGNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 01:13:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=diKVrvkZVqRw0Jqa8af1+ki3Y4FtFkQclHxNbf7glpkxijIdCwqXkTzC/bXfNKxIxx
         q6q2UXH/dYRjQzvH3r1roE1ZovYaaYYT7wInPplxBxb30DTVcciP/4/DveWWUJAIT2vv
         YO2zm1NWBA2tAnSD0tG43HK+j4TiLrqAs8S5E=
Message-ID: <4B31B508.5040903@garzik.org>
Date: Wed, 23 Dec 2009 01:13:28 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <4B2EE5A5.2030208@kernel.org> <1261387377.4314.37.camel@laptop> <4B2F7879.2080901@kernel.org> <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org> <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org> <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain> <20091223060229.GA14805@elte.hu>
In-Reply-To: <20091223060229.GA14805@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 01:02 AM, Ingo Molnar wrote:
> One key thing i havent seen in this discussion are actual measurements. I
> think a lot could be decided by simply testing this patch-set, by looking at
> the hard numbers: how much faster (or slower) did a particular key workload
> get before/after these patches.

We are dealing with situations where drivers are using workqueues to 
provide a sleep-able context, and trying to solve problems related to that.

"faster or slower?" is not very relevant for such cases.

	Jeff


