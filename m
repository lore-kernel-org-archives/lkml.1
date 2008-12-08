Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYLHRPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYLHRPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 12:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYLHRPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 12:15:43 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3970 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbYLHRPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 12:15:42 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: bnx2: fs_sync_timeout, reset code = 1020002
From: "Michael Chan" <mchan@broadcom.com>
To: "Pavel Machek" <pavel@suse.cz>
cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Benjamin Li" <benli@broadcom.com>
In-Reply-To: <20081208145442.GA23820@atrey.karlin.mff.cuni.cz>
References: <20081204105550.GA2429@elf.ucw.cz>
 <1228411378.9156.52.camel@HP1>
 <20081208145442.GA23820@atrey.karlin.mff.cuni.cz>
Date: Mon, 08 Dec 2008 09:12:25 -0800
Message-ID: <1228756345.11235.2.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 652389B937G24552059-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-12-08 at 06:54 -0800, Pavel Machek wrote:
> > 
> > On Thu, 2008-12-04 at 02:55 -0800, Pavel Machek wrote:
> > > Hi!
> > > 
> > > I'm getting `subj` (with different numbers, 1020002, 1020004,
> > > sometimes 102006). ifconfig eth0 up fails, network is completely
> > > broken.
> > 
> > Which kernel are you using?  If it used to work before 2.6.26 or so,
> > it
> 
> I'm using 2.6.28-rc7. I did not try any previous kernels.

Please provide ethtool -i eth0

and lspci -xxx on the Broadcom device.

Thanks.

> 
> > may be because of the PCI VPD access going beyond the size limit.  We
> > should have a PCI quirk to prevent this, but may be it is not
> > complete.
> 
> I could not find quirk handling, so I enabled the debug and workaround
> options I could find...
> 


