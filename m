Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbYB1CmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbYB1CmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 21:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYB1Clz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 21:41:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:56492 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYB1Cly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 21:41:54 -0500
Subject: Re: [PATCH 1/2] firewire: endianess fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jarod Wilson <jwilson@redhat.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <200802271458.28401.jwilson@redhat.com>
References: <20080220220326.GA22328@uranus.ravnborg.org>
	 <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de>
	 <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
	 <200802271458.28401.jwilson@redhat.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 13:40:22 +1100
Message-Id: <1204166422.15052.334.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 14:58 -0500, Jarod Wilson wrote:
> On Saturday 23 February 2008 06:24:17 am Stefan Richter wrote:
> > The generation of incoming requests was filled in in wrong byte order on
> > machines with big endian CPU.
> >
> > Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > Cc: sparclinux@vger.kernel.org
> > Cc: linuxppc-dev@ozlabs.org
> > ---
> >
> > This patch is a shot in the dark, based on a warning when building with
> > C=1 CHECKFLAGS="-D__CHECK_ENDIAN__".  Is it really a fix, or was the
> > previous code accidentally correct?
> >
> > This needs to be tested on different big endian PCs, if possible with
> > the Apple Uninorth FireWire controller and other types of controllers.
> > One test which involves ohci->request_generation is simply with an SBP-2
> > device (harddisk, CD-ROM...).  Does SBP-2 login etc. work?
> 
> Works just fine with the Apple UniNorth controller in my powerbook in cursory 
> testing. Tested with multiple sbp2 hard disks, plugging and unplugging, 
> mounting and unmounting, etc.

Which specific rev/version of the uninorth controller ?

There is the "interesting" one has vendorID Apple and deviceID 0x0018,
the normal ones have different deviceIDs (and are just lucent
controllers afaik).

Ben.


