Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZJHGlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZJHGlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZJHGlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:41:47 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53582 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZJHGlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:41:46 -0400
Date: Thu, 8 Oct 2009 08:41:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2] cfq-iosched: avoid probable slice overrun when
	idling
Message-ID: <20091008064109.GM8703@kernel.dk>
References: <200910071059.01146.czoccolo@gmail.com> <20091007175112.GI8703@kernel.dk> <4e5e476b0910071230x4adf48eava152bebb149d53e4@mail.gmail.com> <200910072315.42047.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910072315.42047.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07 2009, Corrado Zoccolo wrote:
> Idle timer is not armed if remaining slice is less than average think
> time.

Thanks, this looks a lot more appropriate. I will commit it, but expand
your changelog somewhat. The changelog needs to always explain the
rationale behind the change, this one is a bit on the terse side.

-- 
Jens Axboe

