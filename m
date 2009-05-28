Return-Path: <linux-kernel-owner+w=401wt.eu-S1762569AbZE1N4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762569AbZE1N4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbZE1N4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:56:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58385 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZE1N4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:56:45 -0400
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
In-Reply-To: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 15:56:01 +0200
Message-Id: <1243518961.6600.155.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 13:46 +0200, Jens Axboe wrote:
> - Get rid of the explicit wait queues, we can just use wake_up_process()
>   since it's just for that one task.

Ah, good, should clean up those funny prepare/finish_wait thingies that
looked odd.

