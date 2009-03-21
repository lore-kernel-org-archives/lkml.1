Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZCUN0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZCUN0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 09:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZCUN0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 09:26:07 -0400
Received: from cet.com.ru ([195.178.208.66]:45210 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZCUN0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 09:26:06 -0400
Date: Sat, 21 Mar 2009 16:26:01 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 7/8] exofs: Documentation
Message-ID: <20090321132601.GA10099@ioremap.net>
References: <49C1331D.1080805@panasas.com> <1237399858-29537-1-git-send-email-bharrosh@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237399858-29537-1-git-send-email-bharrosh@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Mar 18, 2009 at 08:10:58PM +0200, Boaz Harrosh (bharrosh@panasas.com) wrote:
> +++ b/fs/exofs/BUGS
> @@ -0,0 +1,3 @@
> +- Out-of-space may cause a severe problem if the object (and directory entry)
> +  were written, but the inode attributes failed. Then if the filesystem was
> +  unmounted and mounted the kernel can get into an endless loop doing a readdir.

Does it also mean that damaged media may end up freezing the machine
during the mount?

-- 
	Evgeniy Polyakov
