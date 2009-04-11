Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZDKE0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZDKE0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 00:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZDKEZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 00:25:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:58401 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZDKEZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 00:25:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,171,1239001200"; 
   d="scan'208";a="130331857"
Date: Sat, 11 Apr 2009 12:25:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: +
	readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch
	-fixes.patch added to -mm tree
Message-ID: <20090411042546.GA7737@localhost>
References: <200904102341.n3ANfAxR022088@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904102341.n3ANfAxR022088@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 04:41:09PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes
> has been added to the -mm tree.  Its filename is
>      readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> ERROR: code indent should use tabs where possible
> #42: FILE: include/linux/mm.h:1202:
> +^I^I        struct address_space *mapping,$
> 
> total: 1 errors, 0 warnings, 83 lines checked
> 
> /patches/readahead-record-mmap-read-around-states-in-file_ra_state.patch has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> Please run checkpatch prior to sending patches

Thanks! I used to do the checks one by one:

        scripts/checkpatch.pl `quilt top`

I'll switch to this script for more productive and complete checks:

        #!/bin/sh
        # Usage: ./check-series < patches/series

        CHECKPATCH=/usr/src/linux/scripts/checkpatch.pl

        while read patch
        do     
                scripts/checkpatch.pl patches/$patch
        done

Thanks,
Fengguang
