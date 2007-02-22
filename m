Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbXBVX5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbXBVX5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 18:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXBVX5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 18:57:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbXBVX5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 18:57:09 -0500
Date: Thu, 22 Feb 2007 15:55:23 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Tony Olech <tony.olech@elandigitalsystems.com>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for workqueue creation
Message-Id: <20070222155523.53e649a3.zaitcev@redhat.com>
In-Reply-To: <20070219181549.GB10111@cvg>
References: <20070219181549.GB10111@cvg>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007 21:15:49 +0300, Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> +++ b/drivers/usb/misc/ftdi-elan.c
> @@ -57,9 +57,9 @@ module_param(distrust_firmware, bool, 0);
>  MODULE_PARM_DESC(distrust_firmware, "true to distrust firmware power/overcurren"
>          "t setup");
>  extern struct platform_driver u132_platform_driver;
> -static struct workqueue_struct *status_queue;
> +static struct workqueue_struct *status_queue = NULL;

You better drop this part. Someone is bound to object.

-- Pete
