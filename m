Return-Path: <linux-kernel-owner+w=401wt.eu-S1030484AbXDQPF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484AbXDQPF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964988AbXDQPF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:05:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:52145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbXDQPF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:05:57 -0400
Date: Tue, 17 Apr 2007 08:03:31 -0700
From: Greg KH <gregkh@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       torresmat@gmail.com, conke.hu@gmail.com
Subject: Re: [PATCH] pci-quirks: disable MSI on RS400-200 and RS480
Message-ID: <20070417150331.GA30372@suse.de>
References: <20070416045918.GI10619@htj.dyndns.org> <4624E058.8010808@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624E058.8010808@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 10:57:28AM -0400, Jeff Garzik wrote:
> Tejun Heo wrote:
> >MSI doesn't work on RS400-200 and RS480 requiring pci=nomsi kernel
> >boot parameter for ahci to work.  This patch disables MSI on those
> >chips.
> >
> >  http://thread.gmane.org/gmane.linux.ide/17820
> >  http://thread.gmane.org/gmane.linux.ide/17516
> >  https://bugzilla.novell.com/show_bug.cgi?id=263893
> >
> >Signed-off-by: Tejun Heo <htejun@gmail.com>
> 
> ACK.  Greg will apply, I presume?

Yes, I'll add this to my tree.

thanks,

greg k-h
