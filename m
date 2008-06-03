Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYFCIWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYFCIWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 04:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYFCIWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 04:22:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48463 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYFCIWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 04:22:36 -0400
Date: Tue, 3 Jun 2008 09:22:13 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] clean up duplicated alloc/free_thread_info
Message-ID: <20080603082213.GA28346@flint.arm.linux.org.uk>
Mail-Followup-To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	akpm@linux-foundation.org
References: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 02:02:25PM +0900, FUJITA Tomonori wrote:
> We duplicate alloc/free_thread_info defines on many platforms (the
> majority uses __get_free_pages/free_pages). This patch defines common
> defines and removes these duplicated
> defines. __HAVE_ARCH_THREAD_INFO_ALLOCATOR is introduced for platforms
> that do something different.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
