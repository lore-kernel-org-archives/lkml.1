Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbZKEOkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbZKEOkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbZKEOkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:40:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:43342 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805AbZKEOko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:40:44 -0500
Subject: Re: [PATCH 3/8] powerpc/cpm: Move CPMFCR_* defines into cpm.h
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20091012164918.GC4578@oksana.dev.rtsoft.ru>
Date: Thu, 5 Nov 2009 07:46:40 -0600
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <6C8EB548-0C0F-4559-A1B1-AE397305FD21@kernel.crashing.org>
References: <20091012164841.GA32214@oksana.dev.rtsoft.ru> <20091012164918.GC4578@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2009, at 11:49 AM, Anton Vorontsov wrote:

> The bits are generic to CPM devices, so let's move them to the
> common header file, so drivers won't need to privately reintroduce
> another bunch of the same bits (as we can't include cpm2.h header
> together with cpm1.h).
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> arch/powerpc/include/asm/cpm.h  |   16 ++++++++++++++++
> arch/powerpc/include/asm/cpm2.h |    8 --------
> 2 files changed, 16 insertions(+), 8 deletions(-)

applied to next

- k
