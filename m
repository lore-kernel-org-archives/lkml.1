Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZKENq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZKENq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbZKENq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:46:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:43641 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679AbZKENq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:46:57 -0500
Subject: Re: [PATCH 1/8] powerpc/cpm: Remove SPI defines and spi structs
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20091012164913.GA4578@oksana.dev.rtsoft.ru>
Date: Thu, 5 Nov 2009 07:46:22 -0600
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3090405E-B946-41D5-B911-67F04764BAB7@kernel.crashing.org>
References: <20091012164841.GA32214@oksana.dev.rtsoft.ru> <20091012164913.GA4578@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2009, at 11:49 AM, Anton Vorontsov wrote:

> When cpm2.h included into spi_mpc8xxx driver, the SPI defines
> in the header conflict with defines in the driver.
>
> We don't need them in the header file, so remove them. Plus
> remove "struct spi", we'll use a better version in the driver.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> arch/powerpc/include/asm/cpm1.h |   45  
> ---------------------------------------
> arch/powerpc/include/asm/cpm2.h |   39  
> ---------------------------------
> 2 files changed, 0 insertions(+), 84 deletions(-)

applied to next

- k
