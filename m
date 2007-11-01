Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbXKAIop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbXKAIop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 04:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXKAIoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 04:44:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12313 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbXKAIof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 04:44:35 -0400
Date: Thu, 1 Nov 2007 09:41:46 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kristen.c.accardi@intel.com, linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
Message-ID: <20071101084145.GA5037@kernel.dk>
References: <20071031201308.GK11514@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031201308.GK11514@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31 2007, Jens Axboe wrote:
> Hi,
> 
> My x60 stopped suspending about two days ago. It just freezes after
> printing
> 
> Suspending console(s)
> 
> where it would normally turn everything off and the 'moon' light would
> go on. Posting this message in case somebody else knows what is up, if
> not I'll do a bisect on it tomorrow.

Did the bisect, it points to this commit:

1556594f913fa81d008cecfe46d7211c919a853 is first bad commit
commit 31556594f913fa81d008cecfe46d7211c919a853
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Thu Oct 25 01:33:26 2007 -0400

    [libata] AHCI: add hw link power management support

Booting any kernel after this commit fails suspending to ram, it just
sits there forever.

-- 
Jens Axboe

