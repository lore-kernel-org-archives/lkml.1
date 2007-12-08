Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbXLHI6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbXLHI6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 03:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbXLHI6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 03:58:31 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:43996 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbXLHI6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 03:58:31 -0500
Subject: Re: Possible EXT2 race
From: Jon Masters <jonathan@jonmasters.org>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Dave Jones <davej@redhat.com>, Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0712071355200.5300@chaos.analogic.com>
References: <Pine.LNX.4.61.0712070808030.4642@chaos.analogic.com>
	 <20071207165101.GA26631@redhat.com>
	 <Pine.LNX.4.61.0712071355200.5300@chaos.analogic.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 08 Dec 2007 03:57:54 -0500
Message-Id: <1197104274.6899.3.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-07 at 13:58 -0500, linux-os (Dick Johnson) wrote:
> On Fri, 7 Dec 2007, Dave Jones wrote:
> 
> > On Fri, Dec 07, 2007 at 08:15:42AM -0500, linux-os (Dick Johnson) wrote:
> >
> > > Dec  7 04:05:55 chaos kernel: sd 0:0:1:0: [sdb] Add. Sense: Peripheral device write fault
> >
> > This sounds more like a hardware problem.

> There was an attempt to write beyond the end of the device because
> everything in the file-system was getting trashed. I can read/write
> the 5 year-old SCSI physical drive with no errors from both within
> linux and through the Adaptec BIOS. This problem only occurs
> when I attempt to truncate a file that is being written by another
> task.

Well, that might be how you can reproduce it, but this is almost
certainly a hardware problem and not EXT2 at fault - the filesystem can
only do just so much once its data has been corrupted by an old disk.

Jon.


