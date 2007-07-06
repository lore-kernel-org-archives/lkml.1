Return-Path: <linux-kernel-owner+w=401wt.eu-S1763510AbXGFJi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763510AbXGFJi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761183AbXGFJiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:38:20 -0400
Received: from hades.snarc.org ([212.85.152.11]:2806 "EHLO hades.snarc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760828AbXGFJiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:38:20 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2007 05:38:20 EDT
Date: Fri, 6 Jul 2007 11:21:00 +0200
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminge <shemminger@linux-foundation.org>
Subject: Re: [PATCH] Sky Cpu: use C99 style for struct init
Message-ID: <20070706092100.GA11667@snarc.org>
References: <20070705175910.GG7180@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705175910.GG7180@cvg>
X-Warning: Email may contain unsmilyfied humor and/or satire.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tab@snarc.org (Vincent Hanquez)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 09:59:10PM +0400, Cyrill Gorcunov wrote:
> +      .fasync	= NULL,
> +      .poll	= NULL,
> +      .ioctl	= NULL,

you can remove those since C99 automaticly initialize missing fields to 0.

Cheers,
-- 
Vincent Hanquez
