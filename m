Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYCYH1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYCYH1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 03:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYCYH1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 03:27:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40467 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYCYH1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 03:27:40 -0400
Date: Tue, 25 Mar 2008 00:31:11 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Theodore Tso <tytso@MIT.EDU>
Subject: Re: linux-next: Tree for March 20
Message-ID: <20080325073111.GA17879@kroah.com>
References: <20080320143953.8d6b5a60.sfr@canb.auug.org.au> <20080320045719.GA26938@kroah.com> <20080325174817.6018edd8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325174817.6018edd8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 05:48:17PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Wed, 19 Mar 2008 21:57:19 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > On Thu, Mar 20, 2008 at 02:39:53PM +1100, Stephen Rothwell wrote:
> > > 
> > > driver-core/driver-core-remove-no-longer-used-struct-class_device.patch
> > > 	should be merged late
> 
> I still need to revert this so that the scsi tree can build (st.c).

I'll be sending this to Linus after -rc1 comes out, so it's fine that it
needs to be reverted for now.

> > > driver-core/ib-convert-struct-class_device-to-struct-device.patch
> > > 	conflicts with the infiniband tree
> 
> This still has the same conflicts, but they are papered over by my use of
> git-rerere (which remembers my previous merge fixup and applies it for
> me).

Yeah, __FUNCTION__ fun :(

> > > driver-core/pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
> > > 	breaks non CONFIG_PM builds of drivers/serial/serial_core.c
> 
> This one seems to be fixed.

Glad to hear it.

greg k-h
