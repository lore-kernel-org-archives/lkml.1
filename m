Return-Path: <linux-kernel-owner+w=401wt.eu-S934286AbZJGRta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934286AbZJGRta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbZJGRt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:49:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33675 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZJGRt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:49:29 -0400
Date: Wed, 7 Oct 2009 19:48:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: fix think time allowed for seekers
Message-ID: <20091007174852.GH8703@kernel.dk>
References: <200910071100.07980.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910071100.07980.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07 2009, Corrado Zoccolo wrote:
> CFQ enables idle only for processes that think less than the allowed
> idle time. Since idle time is lower for seeky queues, we should use the
> correct value in the comparison.

Looks good, applied. Thanks!

-- 
Jens Axboe

