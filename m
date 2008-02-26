Return-Path: <linux-kernel-owner+w=401wt.eu-S1762264AbYBZP36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264AbYBZP36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYBZP3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:29:50 -0500
Received: from mail.vyatta.com ([216.93.170.194]:56431 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbYBZP3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:29:49 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.891
Date: Tue, 26 Feb 2008 07:29:43 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       stephen.hemminger@vyatta.com, David Miller <davem@davemloft.net>
Subject: Re: Linux 2.6.24.3 (if_addrlabel.h HEADERS_CHECK failure)
Message-ID: <20080226072943.083c3809@extreme>
In-Reply-To: <47C42477.5090900@gentoo.org>
References: <20080226010024.GA26889@suse.de>
	<20080225195229.11ec1f12.randy.dunlap@oracle.com>
	<47C42477.5090900@gentoo.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 14:38:47 +0000
Daniel Drake <dsd@gentoo.org> wrote:

> Randy Dunlap wrote:
> >> We (the -stable team) are announcing the release of the 2.6.24.3
> >> kernel.
> > 
> > When HEADERS_CHECK=y:
> > 
> > make[3]: *** No rule to make target `/local/linsrc/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by `/local/linsrc/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
> > make[2]: *** [linux] Error 2
> 
> This appears to have been caused by the patch titled:
> 
> 	NET: Add if_addrlabel.h to sanitized headers.
> 
> The patch only adds the unifdef-y entry for this header file, however 
> that header was only added after 2.6.24.
> 
> It seems that this patch was submitted to -stable in error. Stephen, can 
> you confirm?

The patch was meant for 2.6.25 only. 
