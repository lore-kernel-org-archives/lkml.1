Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZGPIgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZGPIgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZGPIgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:36:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:44672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530AbZGPIgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:36:22 -0400
Message-ID: <4A5EE63F.9050205@kernel.org>
Date: Thu, 16 Jul 2009 17:35:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH #tj-block-for-linus] block: fix failfast merge testing
 in elv_rq_merge_ok()
References: <4A5ECC62.7050607@kernel.org> <4A5EDD81.6060409@panasas.com> <4A5EDF90.7090900@kernel.org> <4A5EE2BD.8030100@panasas.com>
In-Reply-To: <4A5EE2BD.8030100@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Jul 2009 08:35:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> OK So could you put a FIXME: and fat comment, on that weird "!"(s)
> everywhere?

Yeap, sure.  How about something like the following?

	/*
	 * Don't merge if failfast settings don't match.  The negation
	 * in front of each condition is necessary because bio and
	 * request flags use different bit positions and the accessors
	 * return those bits directly.  This ugliness will soon go
	 * away.
	 */

-- 
tejun
