Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbZJMLI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbZJMLI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZJMLI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:08:27 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:44210 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZJMLI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:08:26 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AD45F94.8060806@gmail.com>
Date: Tue, 13 Oct 2009 12:08:04 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: Complete sched.h removal from interrupt.h
References: <4AD39B4A.6030305@suse.com>
In-Reply-To: <4AD39B4A.6030305@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
>  drivers/staging/iio/industrialio-core.c    |    2 ++
>   
...
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -19,6 +19,8 @@
>  #include <linux/interrupt.h>
>  #include <linux/poll.h>
>  #include <linux/cdev.h>
> +#include <linux/sched.h>
> +#include <linux/wait.h>
>  #include "iio.h"
>  #include "trigger_consumer.h"
>   
Greg has already picked up a patch for this one, but might make more
sense to drop
that and merge all these fixes as one.  Original patch only added
sched.h though.
Is wait.h due to a similar issue that is going to bite in the future?
(could chase this
down but as you added it seemed easier to ask!)

Thanks,

Jonathan
