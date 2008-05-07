Return-Path: <linux-kernel-owner+w=401wt.eu-S1761840AbYEGVRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761840AbYEGVRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbYEGVQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:16:50 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11029 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbYEGVQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:16:49 -0400
Date: Wed, 7 May 2008 23:16:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tom Zanussi <zanussi@comcast.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [regression?] distcc says: (dcc_pump_sendfile) ERROR: sendfile  returned 0? can't cope (bisected)
Message-ID: <20080507211641.GR16217@kernel.dk>
References: <1210194811.16427.6.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210194811.16427.6.camel@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07 2008, Dan Williams wrote:
> Hi Tom, Jens,
> 
> My build system started reporting these error messages recently.
> Reverting commit c3270e577c18b3d0e984c3371493205a4807db9d on top of
> 2.6.26-rc1 gets things working for me again.

Irk, that patch did scare me a bit (hence I asked Tom to double check as
wel :-). I'll take a look in the morning, all test boxes are off at this
point in time.

-- 
Jens Axboe

