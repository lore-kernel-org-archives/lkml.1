Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbZCZSk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbZCZSk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbZCZSks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:40:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55834 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbZCZSks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:40:48 -0400
Date: Thu, 26 Mar 2009 19:40:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] block: fix inconsistency in I/O stat accounting
	code
Message-ID: <20090326184045.GJ27476@kernel.dk>
References: <49CBA46E.6050306@redhat.com> <49CBA4F4.5040409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CBA4F4.5040409@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26 2009, Jerome Marchand wrote:
> This forces in_flight to be zero when turning off or on the I/O stat
> accounting and stops updating I/O stats in attempt_merge() when
> accounting is turned off.

Good stuff, thanks for doing this Jerome! I'll test it and queue it up
for 2.6.30. Then we can later do a -stable backport as well, if things
work out.

-- 
Jens Axboe

