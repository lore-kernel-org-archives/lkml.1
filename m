Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYIYK66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYIYK66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYIYK6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:58:49 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:53813
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752827AbYIYK6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:58:49 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2008 06:58:48 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am0BALcJ20h8qNU+/2dsb2JhbAAIuy6BZQ
X-IronPort-AV: E=Sophos;i="4.33,308,1220198400"; 
   d="scan'208";a="377082865"
Subject: Re: UIO device name
From: Ben Nizette <bn@niasdigital.com>
To: joakim.tjernlund@transmode.se
Cc: Paul Mundt <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       gregkh@suse.de, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1222337151.12624.293.camel@gentoo-jocke.transmode.se>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se>
	 <20080924093551.GB7591@linux-sh.org>
	 <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
	 <20080924102230.GB2973@local>
	 <1222255981.12624.215.camel@gentoo-jocke.transmode.se>
	 <20080924114743.GA9694@linux-sh.org>
	 <1222259894.12624.247.camel@gentoo-jocke.transmode.se>
	 <1222297057.4037.12.camel@moss.renham>
	 <1222337151.12624.293.camel@gentoo-jocke.transmode.se>
Content-Type: text/plain
Organization: Nias Digital
Date: Thu, 25 Sep 2008 20:48:49 +1000
Message-Id: <1222339729.3938.15.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-09-25 at 12:05 +0200, Joakim Tjernlund wrote:
> On Thu, 2008-09-25 at 08:57 +1000, Ben Nizette wrote:
> > 
> > My software just walks /sys/class/uio/uioX/name, finds the one which
> > matches then opens the corresponding device.  No scripts needed, no
> > in-kernel hackery or policy making, just the interface used as the maker
> > intended.  What's your problem with this approach?
> 
> My problem is this, uio is a generic container for any user space device
> and by itself it doesn't mean much. You put some protocol driver on top
> of uio, such as uio_smx, to make it mean something. 
> 
> Comparing uio with hdX is wrong as hdX means something, it is a block
> device for a disk. 
> A better comparison would be if all kernel devices were named kio%d and
> you had to scan /sys to find the name hdX.

UIO drivers certainly aren't first class citizens like kernel mode
drivers.  They just aren't.

> 
> Look at the spi subsystem, the protocol drivers name them self.

UIO is an interface type, not a bus type.  UIO isn't a subsystem as
such, it's a user interface.  If the interface is consistent (even if
the backing device is different) I don't see the problem with consistent
naming.

Anyway, I don't really see the point arguing here - the interface is
what it is, it does everything it needs to to allow you to identify the
device nodes.  The kernel boys have spent a lot of effort over time
letting userspace identify and name device nodes and I don't really see
the difference here :-)

	--Ben.


