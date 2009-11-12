Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZKLMFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZKLMFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 07:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZKLMFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 07:05:42 -0500
Received: from [95.166.99.235] ([95.166.99.235]:32874 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZKLMFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 07:05:41 -0500
Date: Thu, 12 Nov 2009 13:05:47 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Romit Dasgupta <romit@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/1]: Thaws refrigerated bdi flusher threads before
	invoking kthread_stop on them
Message-ID: <20091112120546.GI8742@kernel.dk>
References: <1257928216.15415.57.camel@boson> <200911111230.58479.rjw@sisk.pl> <20091111193719.GR8742@kernel.dk> <200911112141.12437.rjw@sisk.pl> <1258026726.2341.1.camel@boson>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258026726.2341.1.camel@boson>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12 2009, Romit Dasgupta wrote:
> Resubmitting after incorporationg the suggestions:
> > 
> > Romit, please rework as suggested by Jens and resubmit.
> 
> Unfreezes the bdi flusher task when the said task needs to exit.

Thanks, this looks more palatable. I will merge it and make sure it goes
upstream soon.

-- 
Jens Axboe

