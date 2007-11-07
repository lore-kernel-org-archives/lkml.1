Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbXKGRv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbXKGRv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbXKGRvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:51:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45080 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbXKGRvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:51:48 -0500
Date: Wed, 7 Nov 2007 09:47:47 -0800
From: Greg KH <greg@kroah.com>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andrew Morton <akpm@osdl.org>, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-ID: <20071107174747.GA9918@kroah.com>
References: <20071107003454.GA13374@kroah.com> <20071107134255.GE14646@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107134255.GE14646@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 05:42:55AM -0800, Stephane Eranian wrote:
> Greg,
> 
> Perfmon sysfs document has been updated following your adivce.
> you can check out in my perfmon tree  the following commit:
> 
> 	e83278f879e52ecee025effe9ad509fd51e4a516

Thanks, that looks a lot better.

Do you want me to send you patches based on this tree to help clean up
the sysfs usage now that it's documented?

Also, a lot of your per-cpu sysfs files should probably move to debugfs
as they are for debugging only, right?  No need to clutter up sysfs with
them when only the very few perfmon developers would be needing access
to them.

thanks,

greg k-h
