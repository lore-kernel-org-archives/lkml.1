Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbZHMXdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbZHMXdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 19:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZHMXdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 19:33:46 -0400
Received: from kroah.org ([198.145.64.141]:52735 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbZHMXdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:33:45 -0400
Date: Thu, 13 Aug 2009 16:32:20 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, len.brown@intel.com,
       stable@kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       ranma+kernel@tdiedrich.de
Subject: Re: [stable] patch
 thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch added
 to 2.6.30-stable tree
Message-ID: <20090813233220.GA3507@kroah.com>
References: <20090805205011.57FB548DF1@coco.kroah.org>
 <20090806233111.GB14381@khazad-dum.debian.net>
 <20090813222801.GA9102@kroah.com>
 <200908140102.47341.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908140102.47341.s.L-H@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 01:02:45AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Friday 14 August 2009, Greg KH wrote:
> > On Thu, Aug 06, 2009 at 08:31:11PM -0300, Henrique de Moraes Holschuh wrote:
> > > On Fri, 07 Aug 2009, Stefan Lippers-Hollmann wrote:
> > > > This patch fails to compile if applied to 2.6.30 + current stable queue.
> > > [...]
> > > > It seems to depend on the new quirk handling, introduced in:
> > > > commit 7d95a3d564901e88ed42810f054e579874151999
> > > 
> > > Good catch.  And I _will_ need that quirk handling stuff to keep 2.6.30 in
> > > shape :-(
> > 
> > Oops, sorry for missing this.
> > 
> > > The dependencies for the "thinkpad-acpi: fix incorrect use of
> > > TPACPI_BRGHT_MODE_ECNVRAM" patch are:
> > 
> > Due to the need to add a new feature just to get these quirks to work,
> > I'll just drop this single patch, which should keep everything building
> > properly, right?
> 
> Yes, dropping this patch
> thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch
> results in a buildable tree again.

Thanks again so much for verifying this, I really appreciate it.

greg k-h
