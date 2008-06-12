Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbYFLTVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbYFLTVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbYFLTUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:20:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442AbYFLTUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:20:54 -0400
Date: Thu, 12 Jun 2008 15:20:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm 1/2] kexec jump -v11: kexec jump
Message-ID: <20080612192015.GH9654@redhat.com>
References: <1213082104.22608.29.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213082104.22608.29.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 03:15:04PM +0800, Huang, Ying wrote:
> This patch provides an enhancement to kexec/kdump. It implements
> the following features:
> 
> - Backup/restore memory used by the original kernel before/after
>   kexec.
> 
> - Save/restore CPU state before/after kexec.
> 
> The features of this patch can be used as a general method to call
> program in physical mode (paging turning off). This can be used to
> call BIOS code under Linux.
> 
> 

Hi Huang,

I was testing these patches and I get following error on my machine.

Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
PM: Device i8042 failed to freeze: error -22
Restarting tasks ... done.

Any idea why keyboard controller would not freeze?

Thanks
Vivek
