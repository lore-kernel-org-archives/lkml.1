Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbYLPU5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbYLPU5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYLPU4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:56:54 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60228 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbYLPU4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:56:53 -0500
Date: Tue, 16 Dec 2008 12:56:51 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, Trent Piepho <xyzzy@speakeasy.org>,
       Alex Chiang <achiang@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding
	the?device
Message-ID: <20081216205650.GH25300@plum>
Reply-To: djwong@us.ibm.com
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com> <Pine.LNX.4.58.0811281303230.30153@shell4.speakeasy.net> <200812011808.31906.eike-kernel@sf-tec.de> <200812161133.33894.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161133.33894.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 11:33:33AM -0800, Jesse Barnes wrote:
> > I read it, but that's the way a kernel works: if you want to talk to a
> > device, get a driver. You can write a rather minimal one that does only
> > pci_enable_device() on probe and pci_disable_device() on remove. Try the
> > one posted by Chris Wright in "[PATCH 2/2] PCI: pci-stub module to reserve
> > pci device" as a starting point.
> 
> Ok, so sounds like Darrick's original patch gets a NAK?  I guess the fakephp 
> vs. dummyphp vs. new interface stuff can be dealt with in another thread...

I'd like to be able to (pretend to) add and remove PCI devices via
fakephp until this dummyphp/fakephp/newinterface stuff gets ironed out
and put into mainline.

In any case, I gave 2.6.24 a whirl.  2.6.24 fakephp sets up the BARs
correctly, so technically this is a regression fix too, even if only a
stopgap.

--D
