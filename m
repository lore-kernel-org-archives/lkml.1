Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbZE0VHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbZE0VHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbZE0VHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:07:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbZE0VHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:07:38 -0400
Date: Wed, 27 May 2009 14:06:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: damien.wyart@free.fr, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, jack@suse.cz,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-Id: <20090527140641.71ecaf8c.akpm@linux-foundation.org>
In-Reply-To: <20090527150546.GM11363@kernel.dk>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
	<20090526152501.GA20968@localhost.localdomain>
	<20090526164117.GJ11363@kernel.dk>
	<20090526170845.GA3226@localhost.localdomain>
	<20090526204703.GM11363@kernel.dk>
	<20090526211119.GO11363@kernel.dk>
	<20090527052101.GA28517@localhost.localdomain>
	<20090527054921.GA4127@localhost.localdomain>
	<20090527092052.GV11363@kernel.dk>
	<20090527131555.GA3277@localhost.localdomain>
	<20090527150546.GM11363@kernel.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 17:05:47 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> I ran testing with artificial
> bdi_work allocation failures to verify the oom path

I bet you didn't use lib/fault-inject.c :(

For tricky pieces of core kernel like this, there's a good case for
including and permanently maintaining fault injection testing
capabilities.

