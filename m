Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYHCRmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYHCRmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYHCRmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:42:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41238 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbYHCRmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:42:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata) and IDE
Date: Sun, 3 Aug 2008 19:45:03 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
References: <1217779055.4179.10.camel@localhost.localdomain> <20080803173941.314edf33@lxorguk.ukuu.org.uk> <20080803173254.GI615@1wt.eu>
In-Reply-To: <20080803173254.GI615@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808031945.04160.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 3 of August 2008, Willy Tarreau wrote:
> On Sun, Aug 03, 2008 at 05:39:41PM +0100, Alan Cox wrote:
> > Actually what a material number of embedded systems need is a single
> > dumb-as-a-rock CF only PIO driver which doesn't suck in large chunks of
> > midlayer code. I'm just not sure that trend will continue as CF is giving
> > way to other smaller media.
> 
> I bet we'll see CF for a long time, because it is the only cheap
> removable media to support IDE emulation and be bootable from an
> unmodified PC BIOS. SD is cheaper and will soon provide larger
> capacities, but it still requires a separate controller and is
> not bootable with standard BIOSes.
> 
> Anyway, in my experience, libata supports CF on embedded controllers
> pretty well. So maybe we should start marking IDE drivers deprecated
> to encourage people to try libata instead and report breakage if any.

Well, I know of at least one case of PC hardware in which an old IDE driver
basically works while the libata/pata poeple have no idea why their driver
doesn't:

http://bugzilla.kernel.org/show_bug.cgi?id=9157

Thanks,
Rafael
