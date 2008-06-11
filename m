Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYFKOvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYFKOvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759039AbYFKOvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:51:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866AbYFKOvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:51:00 -0400
Date: Wed, 11 Jun 2008 07:49:55 -0700
From: Greg KH <greg@kroah.com>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 12/21] perfmon2 minimal:  sysfs interface
Message-ID: <20080611144955.GA20145@kroah.com>
References: <484daff1.1358560a.0808.0267@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484daff1.1358560a.0808.0267@mx.google.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 03:34:25PM -0700, eranian@googlemail.com wrote:
> +
> +static struct kobject pfm_kernel_kobj;

Eeek, no, please look at Documentation/kobject.txt that says to not ever
have static kobjects.

I think a lot of this code can be cleaned up and shrunk given the way
that kobjects have changed recently.  See the examples in
samples/kobject/ and the documentation file for more details.

If you have any questions about it, please let me know.

Also, whenever you add a sysfs file to the kernel, please document it in
Documentation/ABI/ so that everyone knows what it is and how to use it.

thanks,

greg k-h
