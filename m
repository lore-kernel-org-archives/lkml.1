Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbYBZUaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbYBZUaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYBZUaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:30:11 -0500
Received: from mail.vyatta.com ([216.93.170.194]:35040 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYBZUaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:30:09 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.335
Date: Tue, 26 Feb 2008 12:30:03 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Greg KH <greg@kroah.com>
Cc: Daniel Drake <dsd@gentoo.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, stephen.hemminger@vyatta.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.24.3 (if_addrlabel.h HEADERS_CHECK failure)
Message-ID: <20080226123003.38c2282f@extreme>
In-Reply-To: <20080226200137.GB10249@kroah.com>
References: <20080226010024.GA26889@suse.de>
	<20080225195229.11ec1f12.randy.dunlap@oracle.com>
	<47C42477.5090900@gentoo.org>
	<20080226072943.083c3809@extreme>
	<20080226200137.GB10249@kroah.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 12:01:37 -0800
Greg KH <greg@kroah.com> wrote:

> On Tue, Feb 26, 2008 at 07:29:43AM -0800, Stephen Hemminger wrote:
> > On Tue, 26 Feb 2008 14:38:47 +0000
> > Daniel Drake <dsd@gentoo.org> wrote:
> > 
> > > Randy Dunlap wrote:
> > > >> We (the -stable team) are announcing the release of the 2.6.24.3
> > > >> kernel.
> > > > 
> > > > When HEADERS_CHECK=y:
> > > > 
> > > > make[3]: *** No rule to make target `/local/linsrc/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by `/local/linsrc/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
> > > > make[2]: *** [linux] Error 2
> > > 
> > > This appears to have been caused by the patch titled:
> > > 
> > > 	NET: Add if_addrlabel.h to sanitized headers.
> > > 
> > > The patch only adds the unifdef-y entry for this header file, however 
> > > that header was only added after 2.6.24.
> > > 
> > > It seems that this patch was submitted to -stable in error. Stephen, can 
> > > you confirm?
> > 
> > The patch was meant for 2.6.25 only. 
> 
> So should it be reverted?  David sent it to me for some reason :)
> 
> thanks,
> 
> greg k-h

yes. please revert it for next build.
