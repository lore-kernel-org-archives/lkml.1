Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbYCGQMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbYCGQMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 11:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbYCGQMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 11:12:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39538 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbYCGQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 11:12:29 -0500
Date: Fri, 7 Mar 2008 08:12:12 -0800
From: Greg KH <greg@kroah.com>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 5/7] regulator: sysfs ABI
Message-ID: <20080307161212.GD28439@kroah.com>
References: <1204827125.15360.151.camel@a10323.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204827125.15360.151.camel@a10323.wolfsonmicro.main>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 06:12:05PM +0000, Liam Girdwood wrote:
> This patch adds a description of the regulator class sysfs ABI to the
> testing directory.

Thanks for doing this, I appreciate it.

> +What:		/sys/class/regulator/.../parent
> +Date:		March 2008
> +KernelVersion:	2.6.25
> +Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
> +Description:
> +		Some regulator directories will contain a link called parent.
> +		This points to the parent or supply regulator if one exists.

I don't think this is needed, why not just parent the device properly in
the device tree itself?

thanks,

greg k-h
