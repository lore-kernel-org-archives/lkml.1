Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbZKZImT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbZKZImT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbZKZImS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:42:18 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57513 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZKZImS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:42:18 -0500
Date: Thu, 26 Nov 2009 09:42:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: cleanup unreachable code
Message-ID: <20091126084223.GN8742@kernel.dk>
References: <200911241701.49677.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911241701.49677.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24 2009, Corrado Zoccolo wrote:
> cfq_should_idle returns false for no-idle queues that are not the last,
> so the control flow will never reach the removed code in a state that
> satisfies the if condition.
> The unreachable code was added to emulate previous cfq behaviour for
> non-NCQ rotational devices. My tests show that even without it, the
> performances and fairness are comparable with previous cfq, thanks to
> the fact that all seeky queues are grouped together, and that we idle at
> the end of the tree.

Applied, thanks.

-- 
Jens Axboe

