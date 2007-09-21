Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbXIUSty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbXIUSty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760110AbXIUStm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:49:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760836AbXIUStl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:49:41 -0400
Date: Fri, 21 Sep 2007 11:48:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
       yur@emcraft.com, saeed.bishara@gmail.com, shannon.nelson@intel.com
Subject: Re: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
Message-Id: <20070921114823.49d00263.akpm@linux-foundation.org>
In-Reply-To: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 18:27:35 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Fix a couple bugs and provide documentation for the async_tx api.
> 
> Neil, please 'ack' patch #3.
> 
> git://lost.foo-projects.org/~dwillia2/git/iop async-tx-fixes-for-linus

Well it looks like Neil is on vacation or is hiding from us or something.

In which case our options would be to go ahead and merge your #3 with
our fingers crossed, or wait and do it in 2.6.23.1 or .2.

How serious is this bug which you're fixing?  Will it affect users
of "legacy" MD setups, or only those who have enabled fancy dma-engine
features?

Either way, we need to get #2 (at least) in to Linus.
