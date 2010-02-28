Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936387Ab0B1SrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:47:01 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57442 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933156Ab0B1Sq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:46:59 -0500
Date: Sun, 28 Feb 2010 19:46:59 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] blktrace: perform cleanup after setup error
Message-ID: <20100228184658.GJ5768@kernel.dk>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org> <1267292113-12900-2-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267292113-12900-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27 2010, Dmitry Monakhov wrote:
> Currently even if BLKTRACESETUP ioctl has failed user must call
> BLKTRACETEARDOWN to be shure what all staff was cleaned, which
> is contr-intuitive.
> Let's setup ioctl make necessery cleanup by it self.

This makes more sense, we should return in with a known state (enabled
or not). Applied.

-- 
Jens Axboe

