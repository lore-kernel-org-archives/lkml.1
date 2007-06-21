Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbXFUM2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbXFUM2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 08:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXFUM1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 08:27:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32793 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbXFUM1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 08:27:54 -0400
Date: Thu, 21 Jun 2007 05:27:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Malte Cornils <malte@cornils.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: PCI setup hangs on Asus Notebook (nolapic helps)
Message-Id: <20070621052741.a44dc7f2.akpm@linux-foundation.org>
In-Reply-To: <200706141505.27380.malte@cornils.net>
References: <200706141505.27380.malte@cornils.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 14 Jun 2007 15:05:27 +0200 Malte Cornils <malte@cornils.net> wrote:
> Hello,
> 
> my Asus M2N Notebook hangs doing the following on 2.6.22-rc3 (from Ubuntu 
> Gutsy Gibbon Tribe-1):
> 
> Setting up standard PCI resources
> 
> The non-scrollable output on the full screen can be found here:
> http://planck.djpig.de/~mcornils/pci-hang.jpg
> 
> Booting with nolapic helps, but makes the SATAized IDE controller buggy 
> (spontaneous timeouts occuring, which do not happen on OpenBSD or Windows XP 
> (shiver)).
> 
> I'm using the latest BIOS (A208). Now I know it's buggy as hell and I've 
> already complained to Asus, but to no avail.
> 
> There have been other reports of the problem on Asus notebooks. I've collected 
> some links:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8278
> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/83290
> http://bugzilla.kernel.org/show_bug.cgi?id=7906 (maybe related)
> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/8012 (maybe 
> related)
> http://lists.debian.org/debian-user-german/2006/12/msg01017.html (german)
> 
> I'm willing to provide any needed information (like DSDT table, system 
> info, ...) and try out almost anything (I do not have a serial console handy 
> though - the system does not have serial). 
> 

Are any of these problems new behaviour, or has it always done this?

If there _is_ new behaviour here, are you able to identify which earlier
kernel versions did not exhibit it?

