Return-Path: <linux-kernel-owner+w=401wt.eu-S932558AbXF2BB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbXF2BB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 21:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762807AbXF2BBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 21:01:20 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50971 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764741AbXF2BBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 21:01:19 -0400
Date: Thu, 28 Jun 2007 14:08:09 -0700
From: Greg KH <greg@kroah.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [patch -mm] s390: struct bin_attribute changes
Message-ID: <20070628210809.GA20253@kroah.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070628133904.GB4343@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628133904.GB4343@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:39:04PM +0200, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> git-acpi contains a patch that adds 'struct bin_attribute *' to
> the read method of struct bin_attribute. This breaks s390:
> 
>   CC      arch/s390/kernel/ipl.o
> arch/s390/kernel/ipl.c:317:
>  warning: initialization from incompatible pointer type
> arch/s390/kernel/ipl.c:340:
>   warning: initialization from incompatible pointer type
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Greg KH <greg@kroah.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Thanks, I've merged this with the original patch so that nothing breaks
when applied to Linus's tree.

greg k-h
