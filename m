Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYGLKHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYGLKHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 06:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYGLKG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 06:06:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43479 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751555AbYGLKG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 06:06:58 -0400
Subject: Re: [PATCH] regulator: include suspend.h in machine.h for
	suspend_state_t
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1215790090.16329.7.camel@localhost.localdomain>
References: <1215790090.16329.7.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 11:06:54 +0100
Message-Id: <1215857214.6634.25.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-11 at 17:28 +0200, Philipp Zabel wrote:
> linux/regulator/machine.h shouldn't depend on files including this
> header to have included linux/suspend.h before.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  include/linux/regulator/machine.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
> index 60e6873..bed2b5e 100644
> --- a/include/linux/regulator/machine.h
> +++ b/include/linux/regulator/machine.h
> @@ -16,6 +16,7 @@
>  #define __LINUX_REGULATOR_MACHINE_H_
>  
>  #include <linux/regulator/consumer.h>
> +#include <linux/suspend.h>
>  
>  struct regulator;
>  

Applied.

Thanks

Liam

