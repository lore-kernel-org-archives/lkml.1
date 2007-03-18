Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbXCRO7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbXCRO7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 10:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXCRO7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 10:59:00 -0400
Received: from ns.suse.de ([195.135.220.2]:42946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXCRO67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 10:58:59 -0400
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6>
From: Andi Kleen <andi@firstfloor.org>
Date: 18 Mar 2007 16:57:57 +0100
In-Reply-To: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6>
Message-ID: <p73y7lu5yt6.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@mindspring.com> writes:

> Delete the allegedly obsolete raw driver feature, which has been
> marked for death since 2005.

I think it would be better to replace it with a wrapper
that forces O_DIRECT and opens the underlying block device.  I suspect 
just dropping it will break many people's database setups, which is not
nice.  Widely used admin interfaces should be only broken when 
there is a very good reason and just "there is a better way now" 
doesn't seem quite strong enough.

-Andi
