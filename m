Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbZKKWVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbZKKWVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759353AbZKKWVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:21:11 -0500
Received: from mail.vyatta.com ([76.74.103.46]:42592 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759372AbZKKWU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:20:58 -0500
Date: Wed, 11 Nov 2009 14:20:42 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Frans Pop <elendil@planet.nl>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: Mount -o sync regression in 2.6.31
Message-ID: <20091111142042.657c1a66@nehalam>
In-Reply-To: <200911112234.24180.elendil@planet.nl>
References: <20091111123340.703f5c86@nehalam>
	<200911112234.24180.elendil@planet.nl>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 22:34:22 +0100
Frans Pop <elendil@planet.nl> wrote:

> Stephen Hemminger wrote:
> > I tried the obvious bisection, but git bisect seems to wonder off into
> > the weeds now. There is no reason that bisecting between v2.6.30 and
> > v2.6.31-rc1 should go off into v2.6.30-rc2
> 
> AFAIK that can happen if some branch was merged after 2.6.30 that happened 
> to be based on a commit from v2.6.30-rc2. Did you check in what branch you 
> were when that happened?
> 
> If you look at 'gitk v2.6.30..v2.6.31-rc1' and scroll to the bottom, you 
> will see quite a few merges of branches that were based on commits from 
> (early) v2.6.30-rcX releases.
> 
> Cheers.
> FJP

That makes sense but is confusing.

-- 
