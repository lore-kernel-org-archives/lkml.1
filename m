Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZGNQPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZGNQPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbZGNQPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:15:47 -0400
Received: from kroah.org ([198.145.64.141]:43037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZGNQPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:15:46 -0400
Date: Tue, 14 Jul 2009 09:15:14 -0700
From: Greg KH <greg@kroah.com>
To: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@redhat.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
Message-ID: <20090714161514.GA2026@kroah.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor comment:

> +#ifdef DEBUG
> +	printk(KERN_DEBUG "%s\n", __func__);
> +#endif

You should just use 'dev_dbg() for any debugging statments like this.
You can turn them on and off dynamically, and you get all of the proper
device information as to what is going on automatically.

Plus, there's no need for a #ifdef in the code, which is generally
frowned apon in .c files.

thanks,

greg k-h
