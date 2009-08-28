Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbZH1Fqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbZH1Fqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 01:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZH1Fqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 01:46:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:45458 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZH1Fqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 01:46:48 -0400
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Message-Id: <C37BD1BB-7F53-4CC7-ABB0-BBBDDAC5C052@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20090818220410.GA25090@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 1/8] powerpc/cpm: Remove SPI defines and spi structs
Date: Fri, 28 Aug 2009 00:45:34 -0500
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru> <20090818220410.GA25090@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 18, 2009, at 5:04 PM, Anton Vorontsov wrote:

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
