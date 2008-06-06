Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYFFNsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYFFNsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYFFNsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:48:14 -0400
Received: from aybabtu.com ([69.60.117.155]:42646 "EHLO aybabtu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYFFNsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:48:13 -0400
X-Greylist: delayed 2284 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2008 09:48:13 EDT
Date: Fri, 6 Jun 2008 15:09:36 +0200
From: Robert Millan <rmh@aybabtu.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de
Subject: Re: [PATCH] OLPC: pci: fix up PCI stuff so that PCI_GOANY supports OLPC
Message-ID: <20080606130936.GA18193@thorin>
References: <20080605152914.6f4ca839@ephemeral> <20080606110549.GA5396@elf.ucw.cz> <20080606084633.65f69d73@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080606084633.65f69d73@ephemeral>
Organization: free as in freedom
X-Message-Flag: Worried about Outlook viruses? Switch to Thunderbird! www.mozilla.com/thunderbird
X-Debbugs-No-Ack: true
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 08:46:33AM -0400, Andres Salomon wrote:
> On Fri, 6 Jun 2008 13:05:49 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > On Thu 2008-06-05 15:29:14, Andres Salomon wrote:
> > > Previously, one would have to specifically choose CONFIG_OLPC and
> > > CONFIG_PCI_GOOLPC in order to enable PCI_OLPC.  That doesn't really
> > > work for distro kernels, so this patch allows one to choose
> > 
> > How do distros work on OLPC, anyway? It lacks normal BIOS, so you
> > can't really use GRUB, right?
> > 								Pavel
> 
> I believe Robert was actually working on grub support.

The OLPC port of GRUB is mostly complete now.  There's a problem with
finding the boot drive though (I'm working on that atm).  Other details
at http://grub.enbug.org/OLPC

As for the BIOS dependency, GRUB 2 is very portable so it wasn't a problem
(we used the existing keyboard driver from the Coreboot port, and the OFW
client framework we already had for powerpc).

> I thought it made
> little sense within the context of OFW, but if it is a requirement to make
> installers happy, so be it.

Some might find it practical to have the GRUB menu & update-grub to autobuild
it :-)

-- 
Robert Millan

<GPLv2> I know my rights; I want my phone call!
<DRM> What good is a phone call… if you are unable to speak?
(as seen on /.)
