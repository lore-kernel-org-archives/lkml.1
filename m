Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYJWDmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYJWDmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 23:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYJWDlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 23:41:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:32814 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYJWDlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 23:41:52 -0400
Message-ID: <48FFF26E.5040904@kernel.org>
Date: Thu, 23 Oct 2008 12:41:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH 2/2] libata: switch to using block layer tagging support
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com> <1224661243-7929-3-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1224661243-7929-3-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Oct 2008 03:41:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> libata currently has a pretty dumb ATA_MAX_QUEUE loop for finding
> a free tag to use. Instead of fixing that up, convert libata to
> using block layer tagging - gets rid of code in libata, and is also
> much faster.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
