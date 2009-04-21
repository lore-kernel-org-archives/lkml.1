Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbZDUQoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbZDUQoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbZDUQmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:42:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:38933 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbZDUQmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:42:42 -0400
Message-ID: <49EDF779.8060000@kernel.org>
Date: Wed, 22 Apr 2009 01:42:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
CC: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 14/14] block: kill rq->data
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-15-git-send-email-tj@kernel.org>
In-Reply-To: <1240331881-28218-15-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 16:42:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Now that all block request data transfer is done via bio, rq->data
> isn't used.  Kill it.
> 
> While at it, make the roles of rq->special and buffer clear.
> 
> [ Impact: drop now unncessary field from struct request ]

Subject line was wrong.  It should have been "block: kill rq->data".
Git tree updated accordingly.

Thanks.

-- 
tejun
