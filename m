Return-Path: <linux-kernel-owner+w=401wt.eu-S1765253AbYBZUM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765253AbYBZUM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764974AbYBZUMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:12:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34160 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764886AbYBZUME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:12:04 -0500
Date: Tue, 26 Feb 2008 12:01:37 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Daniel Drake <dsd@gentoo.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, stephen.hemminger@vyatta.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.24.3 (if_addrlabel.h HEADERS_CHECK failure)
Message-ID: <20080226200137.GB10249@kroah.com>
References: <20080226010024.GA26889@suse.de> <20080225195229.11ec1f12.randy.dunlap@oracle.com> <47C42477.5090900@gentoo.org> <20080226072943.083c3809@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226072943.083c3809@extreme>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 07:29:43AM -0800, Stephen Hemminger wrote:
> On Tue, 26 Feb 2008 14:38:47 +0000
> Daniel Drake <dsd@gentoo.org> wrote:
> 
> > Randy Dunlap wrote:
> > >> We (the -stable team) are announcing the release of the 2.6.24.3
> > >> kernel.
> > > 
> > > When HEADERS_CHECK=y:
> > > 
> > > make[3]: *** No rule to make target `/local/linsrc/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by `/local/linsrc/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
> > > make[2]: *** [linux] Error 2
> > 
> > This appears to have been caused by the patch titled:
> > 
> > 	NET: Add if_addrlabel.h to sanitized headers.
> > 
> > The patch only adds the unifdef-y entry for this header file, however 
> > that header was only added after 2.6.24.
> > 
> > It seems that this patch was submitted to -stable in error. Stephen, can 
> > you confirm?
> 
> The patch was meant for 2.6.25 only. 

So should it be reverted?  David sent it to me for some reason :)

thanks,

greg k-h
