Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZIAJsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZIAJsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 05:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZIAJsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 05:48:03 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:58078 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbZIAJsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 05:48:02 -0400
X-Greylist: delayed 1987 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Sep 2009 05:48:01 EDT
Date: Tue, 1 Sep 2009 11:14:47 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH] [PATCH] CRIS: fix defconfig build failure
Message-ID: <20090901091447.GM18552@axis.com>
References: <20090818150514.GA12868@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818150514.GA12868@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 05:05:14PM +0200, Ingo Molnar wrote:
> The CRIS defconfig fails to build with:
> 
>   drivers/serial/crisv10.c: In function 'rs_wait_until_sent':
>   drivers/serial/crisv10.c:3926: error: implicit declaration of function 'lock_kernel'
>   drivers/serial/crisv10.c:3943: error: implicit declaration of function 'unlock_kernel'
> 
> Include smp_lock.h.

Thanks, added to the cris-tree.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
