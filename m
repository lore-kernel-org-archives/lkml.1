Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYAWDu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYAWDu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 22:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYAWDuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 22:50:19 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57908 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbYAWDuS (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 22:50:18 -0500
Date: Wed, 23 Jan 2008 14:50:01 +1100
From: David Chinner <dgc@sgi.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, knikanth@novell.com
Subject: Re: [PATCH 0/6] IO context sharing
Message-ID: <20080123035001.GL155259@sgi.com>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 10:49:15AM +0100, Jens Axboe wrote:
> Hi,
> 
> Today io contexts are per-process and define the (surprise) io context
> of that process. In some situations it would be handy if several
> processes share an IO context.

I think that the nfsd threads should probably share as
well. It should probably provide an io context per thread
pool....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
