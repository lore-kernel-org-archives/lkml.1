Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbZENPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbZENPp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZENPpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:45:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:55082 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZENPpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:45:11 -0400
Message-ID: <4A0C3CC9.8090706@kernel.org>
Date: Fri, 15 May 2009 00:46:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] block: completion related functions cleanup
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <4A0C2297.5040001@panasas.com> <4A0C2515.9060602@kernel.org> <4A0C2769.4090508@panasas.com>
In-Reply-To: <4A0C2769.4090508@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 14 May 2009 15:45:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Thu, 14 May 2009 16:46:03 +0300
> Subject: [PATCH] scsi_lib: remove unused variable
> 
> The last request completion cleanup in scsi_lib left an unused
> this_count variable in scsi_io_completion().
> (It was used before in a code segment that now uses blk_end_request_all())
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
