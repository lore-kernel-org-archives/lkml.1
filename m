Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbZHET57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbZHET57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZHET56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:57:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZHET55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:57:57 -0400
Date: Wed, 5 Aug 2009 21:57:57 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 6/9] writeback: allow sleepy exit of default writeback
	task
Message-ID: <20090805195757.GE27505@duck.suse.cz>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-7-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248989044-21605-7-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 30-07-09 23:24:01, Jens Axboe wrote:
> Since we do lazy create of default writeback tasks for a bdi, we can
> allow sleepy exit if it has been completely idle for 5 minutes.
  Maybe there should be a sysfs tunable to this?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
