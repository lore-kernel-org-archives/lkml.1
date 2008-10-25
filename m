Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYJYLQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYJYLQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 07:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYJYLQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 07:16:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50230 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYJYLQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 07:16:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: 2.6.27-rc8-git8: oops in process hald-addon-dell-backlight (intel iommu related?)
Date: Sat, 25 Oct 2008 13:21:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <pan.2008.10.08.20.15.37@telenet.be> <200810242349.02738.rjw@sisk.pl> <1224890754.13640.36.camel@Anastacia.local>
In-Reply-To: <1224890754.13640.36.camel@Anastacia.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810251321.33709.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 of October 2008, Frederik Himpe wrote:
> On vr, 2008-10-24 at 23:49 +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 8 of October 2008, Frederik Himpe wrote:
> > > On Wed, 08 Oct 2008 20:15:37 +0000, Frederik Himpe wrote:
> > > 
> > > > On my Dell Latitude E6400 system with Intel chipset and graphics, I get
> > > > this oops in my 2.6.27-rc8-git8 based kernel, which probably happens
> > > > when hald-addon-dell-backlight is started.
> > > > 
> > > > Complete dmesg and lspci info:
> > > > https://qa.mandriva.com/show_bug.cgi?id=44711
> > > 
> > > Booting with intel_iommu=off seems to fix this issue, and seems to make my 
> > > e1000e based network card stop from giving "transmit timed out" errors 
> > > after which it stopped working.
> > 
> > Is it necessary to boot 2.6.27 final on this box with intel_iommu=off, and if
> > so, is it still necessary in mainline?
> 
> I just tested stock 2.6.27.3 and this machine (Dell Latitude E6400) is
> totally unusable without intel_iommu=off if Intel VT is enabled in the
> BIOS. During the boot process, stack traces start scrolling over the
> screen. In the end, it goes on starting X, and from that moment, the
> machine locks up completely. Booting in runlevel 3, I see lots of stack
> traces (too much to even be able to read them).
> 
> In the past (with Mandriva's 2.6.27-rc) it would at least succeed in
> booting (with one or a few backtraces), but even then the e1000e network
> card would timeout a few seconds after when starting to transfer some
> data, after which the network was totally unusable until a reboot. A
> reader of my blog confirmed having the same problem on this same type of
> laptop and also solving it by using intel_iommu=off.
> 
> I entered some more information here:
> http://bugzilla.kernel.org/show_bug.cgi?id=11821

OK, thanks.

I won't consider this as a regression, then.

Rafael
