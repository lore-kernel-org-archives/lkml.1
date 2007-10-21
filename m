Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbXJUQkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbXJUQkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 12:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXJUQkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 12:40:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:42696 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbXJUQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 12:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dfVC5Rr4qgCjUjph7XsGlu/agBlF8ml4KUGsVKVOdWguP/C1+Z5C1nTz02UVbD0l0QNHUjCA0X3umvkJNZRvsvl4iFxW5bHP959YJGC7myqbEFEHGGoAlZLGkYUbLqZFxPhPjOwbI+EJwXJXVCgPoPpNunoO9DsIP+WrqRI+5X4=
Message-ID: <8bd0f97a0710210940k6eeae8f2o67d63eee148dcbe5@mail.gmail.com>
Date: Sun, 21 Oct 2007 12:40:22 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH 17/17] RTC interrupt handling cleanups
Cc: LKML <linux-kernel@vger.kernel.org>, a.zummo@towertech.it
In-Reply-To: <20071021075256.0975B19041E@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
	 <20071021075256.0975B19041E@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/07, Jeff Garzik <jeff@garzik.org> wrote:
> commit f94d41db30d6430bc6d3e53602258d3933f93103
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Sun Oct 21 01:51:50 2007 -0400
>
>     RTC interrupt handling cleanups
>
>     rtc-bfin: calling spin_lock_irq() in interrupt handler marked
>     IRQF_DISABLED is unwise.  Use safer spin_lock_irqsave() instead.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>

thanks :)
-mike
