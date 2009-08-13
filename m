Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbZHMXCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbZHMXCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 19:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZHMXCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 19:02:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:36345 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753496AbZHMXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:02:46 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/EmYV6og3EMUgW7AVcJhI9owEHdOi/QuKdf/UikW
	vcNHwJB3yHbJpM
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] patch thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch added to 2.6.30-stable tree
Date: Fri, 14 Aug 2009 01:02:45 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-sidux-amd64; KDE/4.3.0; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, len.brown@intel.com,
       stable@kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       ranma+kernel@tdiedrich.de
References: <20090805205011.57FB548DF1@coco.kroah.org> <20090806233111.GB14381@khazad-dum.debian.net> <20090813222801.GA9102@kroah.com>
In-Reply-To: <20090813222801.GA9102@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908140102.47341.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 14 August 2009, Greg KH wrote:
> On Thu, Aug 06, 2009 at 08:31:11PM -0300, Henrique de Moraes Holschuh wrote:
> > On Fri, 07 Aug 2009, Stefan Lippers-Hollmann wrote:
> > > This patch fails to compile if applied to 2.6.30 + current stable queue.
> > [...]
> > > It seems to depend on the new quirk handling, introduced in:
> > > commit 7d95a3d564901e88ed42810f054e579874151999
> > 
> > Good catch.  And I _will_ need that quirk handling stuff to keep 2.6.30 in
> > shape :-(
> 
> Oops, sorry for missing this.
> 
> > The dependencies for the "thinkpad-acpi: fix incorrect use of
> > TPACPI_BRGHT_MODE_ECNVRAM" patch are:
> 
> Due to the need to add a new feature just to get these quirks to work,
> I'll just drop this single patch, which should keep everything building
> properly, right?

Yes, dropping this patch
thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch
results in a buildable tree again.

> thanks,
> 
> greg k-h

Regards
	Stefan Lippers-Hollmann
