Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYCEPhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYCEPhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbYCEPhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:37:39 -0500
Received: from ns1.suse.de ([195.135.220.2]:37349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbYCEPhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:37:37 -0500
Date: Wed, 5 Mar 2008 07:37:26 -0800
From: Greg KH <gregkh@suse.de>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Ingo Molnar <mingo@elte.hu>, "Zhang, Rui" <rui.zhang@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Message-ID: <20080305153726.GA28806@suse.de>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com> <20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu> <20080305101617.GD19059@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305101617.GD19059@localhost.sw.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 01:16:17PM +0300, Alexey Dobriyan wrote:
> On Tue, Mar 04, 2008 at 02:54:47PM +0100, Ingo Molnar wrote:
> > CONFIG_SYSFS_DEPRECATED=y changed its meaning recently and causes
> > regressions in working setups that had SYSFS_DEPRECATED disabled.
> > 
> > so rename it to SYSFS_DEPRECATED_V2 so that testers pick up the new
> > default via 'make oldconfig', even if their old .config's disabled
> > CONFIG_SYSFS_DEPRECATED ...
> 
> It has all the same help text, so people who disabled it in the past
> will disable again!

I did change the help text.  If you think the new wording is not
sufficient, please send me a patch against 2.6.25-rc4.

thanks,

greg k-h
