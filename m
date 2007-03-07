Return-Path: <linux-kernel-owner+w=401wt.eu-S965416AbXCGS3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416AbXCGS3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965424AbXCGS3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:29:53 -0500
Received: from av-gw2.cc.tut.fi ([130.230.130.111]:40725 "EHLO
	av-gw2.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965416AbXCGS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:29:51 -0500
X-Greylist: delayed 1142 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 13:29:51 EST
X-AuditID: 82e6826f-afb13bb0000003c5-de-45ef0028b756 
Date: Wed, 7 Mar 2007 20:10:47 +0200
From: Petri Kaukasoina <kaukasoina703m4dpy9@sci.fi>
To: stable@kernel.org, Jan Beulich <jbeulich@novell.com>,
       Alan <alan@lxorguk.ukuu.org.uk>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] adjust legacy IDE resource setting
Message-ID: <20070307181047.GA5021@elektroni.phys.tut.fi>
Mail-Followup-To: stable@kernel.org, Jan Beulich <jbeulich@novell.com>,
	Alan <alan@lxorguk.ukuu.org.uk>, alan@redhat.com,
	linux-kernel@vger.kernel.org
References: <45D33344.76E4.0078.0@novell.com> <20070214154014.7fa76711@localhost.localdomain> <45D33CF9.76E4.0078.0@novell.com> <20070214160936.54b3c730@localhost.localdomain> <45D33344.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214160936.54b3c730@localhost.localdomain> <45D33344.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 03:05:24PM +0000, Jan Beulich wrote:
> The change to force legacy mode IDE channels' resources to fixed
> non-zero values confuses (at least some versions of) X, because the
> values reported by the kernel and those readable from PCI config space
> aren't consistent anymore. Therefore, this patch arranges for the
> respective BARs to also get updated if possible.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> --- linux-2.6.20/drivers/pci/probe.c	2007-02-04 19:44:54.000000000 +0100
> +++ 2.6.20-pci-ide-legacy/drivers/pci/probe.c	2007-02-14 15:54:58.000000000 +0100

...

On Wed, Feb 14, 2007 at 04:09:36PM +0000, Alan wrote:
> > Of course I also opened a bug against X, as I too think it's doing something
> > wrong here.
> 
> If you can add a comment about why it is done (X problem) then it looks
> fine to me.

This would be nice in 2.6.20-stable, too.
