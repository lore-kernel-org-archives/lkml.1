Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYKSJTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYKSJTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYKSJSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:18:46 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37892 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbYKSJSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:18:45 -0500
Date: Wed, 19 Nov 2008 10:16:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do not free io context when taking recursive faults in do_exit
Message-ID: <20081119091656.GU26308@kernel.dk>
References: <200811191215.35438.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811191215.35438.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19 2008, Nikanth Karthikesan wrote:
> When taking recursive faults in do_exit, if the io_context is not null, 
> exit_io_context() is being called. But it might decrement the refcount 
> more than once. It is better to leave this task alone.

Agree, it's better to just leave that alone. Applied to for-2.6.29.

-- 
Jens Axboe

