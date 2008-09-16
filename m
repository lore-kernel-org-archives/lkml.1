Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYIPKTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYIPKTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 06:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYIPKSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 06:18:52 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:24511 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYIPKSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 06:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KDB6eD++FA5iNjd5oc32+r49pabz5p6jrT+qYAJhNy8Bh75IgBbJ1XIOt5Qfj6bk0x
         gfcb9X6TDuWnBJnXXiXTtyG4W5FhERecuhFqmaVQ3Ebwz60jC8PJlszI4QLZDmfM2PPv
         GKHrShwslyqQWwmU7kDHWY0cuF13FaRVrcUGs=
Date: Tue, 16 Sep 2008 14:20:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] pci: using pci_printk
Message-ID: <20080916102052.GD21012@x200.localdomain>
References: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com> <1221555174-30060-3-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221555174-30060-3-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 01:52:52AM -0700, Yinghai Lu wrote:
> --- linux-2.6.orig/drivers/pci/probe.c
> +++ linux-2.6/drivers/pci/probe.c
> @@ -304,7 +304,7 @@ static int __pci_read_base(struct pci_de

> -			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> +			pci_printk(KERN_LOG_DEBUG, KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
				   ^^^^^^^^^^^^^^^^^^^^^^^^^^

Brilliant, simply brilliant!

Printk haters club is definitely creative, no questions.
