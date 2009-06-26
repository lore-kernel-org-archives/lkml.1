Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZFZQqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZFZQqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZFZQqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:46:40 -0400
Received: from bar.sig21.net ([80.81.252.164]:43162 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbZFZQqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:46:40 -0400
X-Greylist: delayed 3054 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2009 12:46:39 EDT
Date: Fri, 26 Jun 2009 17:55:46 +0200
From: Martin Mueller <mm@sig21.net>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel locks up when idle on VIA-nano U2300 with VIA VX800 on
	Jetway JNF76-N1GL-LF mainboard
Message-ID: <20090626155542.GA26353@caesar.sig21.net>
Mail-Followup-To: Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel@vger.kernel.org
References: <20090426095121.GS26701@catull.sig21.net> <gt1jsf$hb8$1@ger.gmane.org> <20090426170602.GA26009@catull.sig21.net> <20090601201951.01a48d3e@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601201951.01a48d3e@dhcp-100-2-144.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-21-Score: -2.0 (--)
X-Spam-21-Report: No, score=-2.0 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.496,BAYES_20=-0.74 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 01, 2009 at 08:19:51PM -0400, Chuck Ebbert wrote:
> On Sun, 26 Apr 2009 19:06:02 +0200
> Martin Mueller <mm@sig21.net> wrote:
> 
> > Hi Jeffrey,
> > 
> > On Sun, Apr 26, 2009 at 12:25:51PM +0000, Jeffrey Cao wrote:
> > > On 2009-04-26, Martin Mueller <mm@sig21.net> wrote:
> > 
> > > > Next, I downloaded linux-2.6.30-rc3, compiled a minimal version with
> > > > just initrd. I left out PCI-support, ACPI and almost everything else
> > > > menuconfig allowed me to unselect except the VGA text console. This
> > > > kernel locked up after giving me the initial prompt from busybox in
> > > > the initrd.
> > > >
> > > > When adding the following lines in the script executed by the kernel
> > > > after booting in the initrd, the system actually works:
> > > >
> > > >   while true; do true; done &
> > > >   /bin/sh
> > > >
> > > > As soon as I kill the shell loop, the system freezes again.
> > > >
> > > > So my conclusion is: the kernel locks up the first time the CPU
> > > > is idle.
> > 
> > > This seems something to do with the board and the hard disk drive.
> > 
> > Thanks for your suggestion, but it has nothing to do with the hardisk.
> > As I wrote above, the problem is reproducible with only an initrd, vga
> > text console, keyboard and no other driver loaded or compiled in.
> > 
> > The kernel freezes as soon as it get's idle the first time.
> > 
> 
> Adding idle=halt to the boot options works. idle=nomwait should work too but
> it doesn't.

Thanks for your suggestion it worked fine. Yesterday I did a BIOS
update (A03) from jetway, which contained a microcode update for the
CPU. Since then it also works without this bootparam.

bye
  MM
--
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?
