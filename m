Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYCTFZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYCTFZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 01:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYCTFZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 01:25:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58215 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbYCTFY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 01:24:59 -0400
Date: Wed, 19 Mar 2008 21:57:19 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Theodore Tso <tytso@MIT.EDU>
Subject: Re: linux-next: Tree for March 20
Message-ID: <20080320045719.GA26938@kroah.com>
References: <20080320143953.8d6b5a60.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320143953.8d6b5a60.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 02:39:53PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (tar balls at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64.
> 
> I have started this tree by reverting the following:
> driver-core/driver-core-remove-no-longer-used-struct-class_device.patch
> 	should be merged late
> driver-core/ib-convert-struct-class_device-to-struct-device.patch
> 	conflicts with the infiniband tree
> driver-core/pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
> 	breaks non CONFIG_PM builds of drivers/serial/serial_core.c

These should be fixed tomorrow, I have new ones in my inbox to solve
these issues (I hope...)

thanks,

greg k-h
