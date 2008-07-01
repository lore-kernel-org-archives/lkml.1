Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYGAIXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYGAIXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYGAIXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:23:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:56438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYGAIXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:23:39 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: use cmpxchg in aio_read_evt() instead of aio_ring_info->ring_lock
Date: Tue, 1 Jul 2008 13:57:52 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>
References: <200806260932.53563.knikanth@suse.de> <48692008.3010003@oracle.com>
In-Reply-To: <48692008.3010003@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807011357.52407.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008 23:33:52 Zach Brown wrote:
> Nikanth Karthikesan wrote:
> > Use cmpxchg in aio_read_evt() and remove the aio_ring_info->ring_lock
>
> I don't think this is safe because the cmpxhg() can't differentiate the
> 0 it read at one point with a 0 that it reads in the future after other
> racing threads have done enough work on the ring index to wrap it.
>

Yes, this is unsafe. Thanks for the review.

Thanks
Nikanth Karthikesan


