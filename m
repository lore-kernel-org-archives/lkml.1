Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbXIMLzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbXIMLzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 07:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbXIMLzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 07:55:39 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2569 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXIMLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 07:55:39 -0400
Date: Thu, 13 Sep 2007 12:55:21 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, bryan.wu@analog.com
Subject: Re: [patch] add some Blackfin specific checks to checkpatch.pl
Message-ID: <20070913115521.GB5146@shadowen.org>
References: <200708211829.59975.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708211829.59975.vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 06:29:59PM -0400, Mike Frysinger wrote:
> Check for a few common errors in Blackfin-specific code wrt MMR loading in
> assembly and doing core/system syncs.

If we are going to pull arch specific things into checkpatch I think we
need to make sure we are pretty specific about where we apply them.  I
am assuming these checks only make sense againt some files in the arch
tree?

-apw
