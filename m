Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZCIXxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZCIXxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 19:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZCIXxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 19:53:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:60602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbZCIXxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 19:53:45 -0400
Date: Mon, 9 Mar 2009 16:53:09 -0700
From: Greg KH <gregkh@suse.de>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: "David A. Schleef" <ds@schleef.org>, linux-kernel@vger.kernel.org
Subject: Re: comedi/drivers.c uses PAGE_KERNEL_NOCACHE
Message-ID: <20090309235309.GA15530@suse.de>
References: <20090309223139.GA27316@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309223139.GA27316@deprecation.cyrius.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 11:31:39PM +0100, Martin Michlmayr wrote:
> I noticed the following build failure in comedi/drivers.c on ARM:
> 
> | drivers/staging/comedi/drivers.c:497: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
> 
> Apparently Geert Uytterhoeven pointed out this problem back in January:
> "which requires PAGE_KERNEL_NOCACHE, which is defined on 4 out of 22
> architectures only (x86, frv, m32r, mn10300)." - http://lkml.org/lkml/2009/1/12/45
> 
> Is anything being done about this problem?

Oops, sorry, no, I missed that one.

Care to send a patch to fix it up?

thanks,

greg k-h
