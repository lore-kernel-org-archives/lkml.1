Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbYILQ5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbYILQ5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 12:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYILQ5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 12:57:09 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43292 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbYILQ5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 12:57:08 -0400
Subject: Re: [RFC v4][PATCH 4/9] Memory management (dump)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <1220946154-15174-5-git-send-email-orenl@cs.columbia.edu>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-5-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 09:57:04 -0700
Message-Id: <1221238624.17910.32.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote: 
> +	if (unlikely(ret < 0)) {
> +		nr = pgarr->nr_free - nr;
> +		while (nr--)
> +			page_cache_release(*(--pagep));
> +		return ret;
> +	}

Oren, please take a good, hard look through all these patches (i.e.
grep) and find all of the (un)likely calls and toss them out.  They're
unneeded.
> 
-- Dave

