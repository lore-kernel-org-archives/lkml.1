Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbZE1Oli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbZE1Oli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZE1Ol3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:41:29 -0400
Received: from thunk.org ([69.25.196.29]:48976 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZE1Ol3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:41:29 -0400
Date: Thu, 28 May 2009 10:41:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090528144118.GS26625@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
	jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
	damien.wyart@free.fr
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 01:46:33PM +0200, Jens Axboe wrote:
> Hi,
> 
> Here's the 9th version of the writeback patches. Changes since v8:
> 
> - Fix a bdi_work on-stack allocation hang. I hope this fixes Ted's
>   issue.

It appears to have fixed the soft lockup hang when running fsstress,
thanks!!

					- Ted

