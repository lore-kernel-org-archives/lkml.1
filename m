Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbXC0C1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbXC0C1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 22:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933951AbXC0C1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 22:27:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:55070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933949AbXC0C1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 22:27:08 -0400
Date: Mon, 26 Mar 2007 19:26:57 -0700
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: bunk@stusta.de, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC: 2.6.21 patch] let PCI_MSI depend on EXPERIMENTAL
Message-ID: <20070327022657.GA24112@suse.de>
References: <20070327010247.GW16477@stusta.de> <20070326.182422.115910859.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326.182422.115910859.davem@davemloft.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 06:24:22PM -0700, David Miller wrote:
> From: Adrian Bunk <bunk@stusta.de>
> Date: Tue, 27 Mar 2007 03:02:47 +0200
> 
> > We had during the last months have quite a few MSI bugs and even 
> > regressions due to:
> > - core kernel bugs,
> > - device driver bugs and
> > - hardware bugs
> > 
> > OTOH, MSI doesn't bring any real advantages for most users.
> > 
> > Let's therefore mark PCI_MSI as EXPERIMENTAL.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> This is a good way to ensure that the code doesn't get tested
> enough to ever fix the problems.

I agree, we need to leave it as it is.  Now that Vista is out with
support for MSI, we will start to get more hardware that actually works
properly with it...

thanks,

greg k-h
