Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbZFJGhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbZFJGhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZFJGhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:37:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:42458 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbZFJGhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:37:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,338,1241420400"; 
   d="scan'208";a="152604811"
Date: Wed, 10 Jun 2009 14:37:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jake <ellowitz@uchicago.edu>, tj@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13463] Poor SSD performance
Message-ID: <20090610063746.GA26773@localhost>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.23.sj7KKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AN6kEAA5GQ.A.23.sj7KKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13463
> Subject		: Poor SSD performance
> Submitter	: Jake <ellowitz@uchicago.edu>
> Date		: 2009-06-05 17:37 (3 days old)

Hi Jake,

Could you collect some blktrace data for the dd commands on new/old
kernels?

dd if=/dev/sda of=/dev/null bs=1M count=1024 iflag=direct
dd if=/dev/sda of=/dev/null bs=1M count=1024


You need to install the blktrace tool and run these commands:

        cd /dev/shm
        blktrace /dev/sda # do this while dd is running
        # ^C to interrupt
        blkparse sda


Package: blktrace
Description: utilities for block layer IO tracing
 blktrace is a block layer IO tracing mechanism which provides detailed
 information about request queue operations up to user space. There are

Thanks,
Fengguang

