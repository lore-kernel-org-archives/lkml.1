Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYIXEMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYIXEMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 00:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYIXEMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 00:12:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:57412 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbYIXEMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 00:12:30 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>, Timur Tabi <timur@freescale.com>,
       Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <B8BAAB1F-10B5-419D-84A7-F724A7E77F41@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20080924000336.GB29733@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH 2/4] powerpc/qe: new call to revert a gpio to a dedicated function
Date: Tue, 23 Sep 2008 23:07:00 -0500
References: <20080924000255.GA28054@oksana.dev.rtsoft.ru> <20080924000336.GB29733@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 23, 2008, at 7:03 PM, Anton Vorontsov wrote:

> qe_gpio_set_dedicated() is a platform specific function, which is used
> to revert a pin to a dedicated function. Caller should have already
> obtained the gpio via gpio_request().
>
> This is needed to support Freescale USB Host Controller.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> arch/powerpc/include/asm/qe.h     |    1 +
> arch/powerpc/sysdev/qe_lib/gpio.c |   46 ++++++++++++++++++++++++++++ 
> +++++++++
> 2 files changed, 47 insertions(+), 0 deletions(-)

what do you mean by dedicated function.. be a bit clearer in the  
commit log.  Also, does this depend on gpio_to_chip() patch?

- k
