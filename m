Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309Ab0ADF4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0ADF4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266Ab0ADF4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:56:51 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:52587 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0ADF4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:56:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k9eGCZDYs/YxQpQkl9A5u+7b3NaRy50n9TgPyFlIfjePSQkMcMtkvNl0a8q7LKmiKe
         sv6X6ar1pYZtYD3nsYFy5JqXUIxWZH9YH9MZYgqcHl12C6IFvfgXi6J8FSGPCEcApzCK
         96gyGhD7WnTNMZYv4MSsp/H5AP6QUdeHGKQho=
Date: Sun, 3 Jan 2010 23:56:44 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: instant reboot on loading 2.6.33-rc on Celeron 900
Message-ID: <20100104055644.GA7082@progeny.tock>
References: <alpine.SOC.1.00.0912291553160.12082@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.0912291553160.12082@math.ut.ee>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos wrote:

> I tried 2.6.33-rc2 today on a Celeron 900 PC (with gcc 4.4.2 (Debian 
> 4.4.2-7)). Selecting the kernel in grub results in instant reboot. Last 
> tested kernel was 2.6.32-05594-g3ef884b compiled with gcc 4.3.4 (Debian 
> 4.3.4-6) and that works.
> 
> I can probably bisect itwith gcc 4.4, but meanwhile it's here - maybe 
> rings a bell to someone. 
[...]
> CONFIG_KERNEL_LZMA=y

I am guessing /bin/sh is dash.  If so, hopefully the patch at
<http://thread.gmane.org/gmane.linux.kbuild.devel/4313/focus=4319> will
fix this.  Please do let me know if it does.

Thanks,
Jonathan
