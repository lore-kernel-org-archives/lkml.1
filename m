Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbZKKVeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbZKKVeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbZKKVeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:34:20 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:52633 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759055AbZKKVeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:34:20 -0500
From: Frans Pop <elendil@planet.nl>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Mount -o sync regression in 2.6.31
Date: Wed, 11 Nov 2009 22:34:22 +0100
User-Agent: KMail/1.9.9
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <20091111123340.703f5c86@nehalam>
In-reply-To: <20091111123340.703f5c86@nehalam>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911112234.24180.elendil@planet.nl>
X-OriginalArrivalTime: 11 Nov 2009 21:34:24.0571 (UTC) FILETIME=[BD0DD0B0:01CA6316]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> I tried the obvious bisection, but git bisect seems to wonder off into
> the weeds now. There is no reason that bisecting between v2.6.30 and
> v2.6.31-rc1 should go off into v2.6.30-rc2

AFAIK that can happen if some branch was merged after 2.6.30 that happened 
to be based on a commit from v2.6.30-rc2. Did you check in what branch you 
were when that happened?

If you look at 'gitk v2.6.30..v2.6.31-rc1' and scroll to the bottom, you 
will see quite a few merges of branches that were based on commits from 
(early) v2.6.30-rcX releases.

Cheers.
FJP
