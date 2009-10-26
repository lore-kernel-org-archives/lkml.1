Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbZJZLfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbZJZLfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZJZLfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:35:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51353 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691AbZJZLfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:35:51 -0400
Date: Mon, 26 Oct 2009 12:35:55 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC]cfq-iosched: improve hw_tag detection
Message-ID: <20091026113555.GB10727@kernel.dk>
References: <20091026091624.GA1169@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026091624.GA1169@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26 2009, Shaohua Li wrote:
> If active queue hasn't enough requests and idle window opens, cfq will not
> dispatch sufficient requests to hardware. In such situation, current code
> will zero hw_tag. But this is because cfq doesn't dispatch enough requests
> instead of hardware queue doesn't work. Don't zero hw_tag in such case.

Thanks, that looks like a good fix. Curious, is this fixing some
regression at your end?

-- 
Jens Axboe

