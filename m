Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYKFHoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYKFHoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYKFHoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:44:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48006 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbYKFHoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:44:15 -0500
Date: Thu, 6 Nov 2008 08:42:46 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 ver 2] Add round_jiffies_up and related routines
Message-ID: <20081106074246.GS21867@kernel.dk>
References: <20081105191126.GN21867@kernel.dk> <Pine.LNX.4.44L0.0811051617300.2187-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811051617300.2187-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05 2008, Alan Stern wrote:
> This patch (as1158b) adds round_jiffies_up() and friends.  These
> routines work like the analogous round_jiffies() functions, except
> that they will never round down.
> 
> The new routines will be useful for timeouts where we don't care
> exactly when the timer expires, provided it doesn't expire too soon.

Thanks Alan, applied 1-2 for 2.6.28.

-- 
Jens Axboe

