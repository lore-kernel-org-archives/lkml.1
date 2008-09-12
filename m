Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYILN1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYILN1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYILN0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:26:55 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48719 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYILN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:26:54 -0400
Date: Fri, 12 Sep 2008 07:26:37 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PCI: Add ALI M5229 comaptibility mode quirk
Message-ID: <20080912132637.GB10844@parisc-linux.org>
References: <20080912112252.505651015@fluff.org.uk> <20080912123339.GA10844@parisc-linux.org> <20080912130043.GF322@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912130043.GF322@trinity.fluff.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 02:00:43PM +0100, Ben Dooks wrote:
> On Fri, Sep 12, 2008 at 06:33:40AM -0600, Matthew Wilcox wrote:
> > On Fri, Sep 12, 2008 at 12:22:52PM +0100, Ben Dooks wrote:
> > > The M5229 implementation embedded into the ALI M1543 uses the
> > > M1543's ISA PIC to provide the interrupts and thus does not have
> > > an valid PCI IRQ set. This quirk detects the abscence of IRQ and
> > > sets the M5229 back into compatibility mode to use IRQs 14 and 15
> > > so that libata works correctly.
> > 
> > Why does this need to be a quirk rather than something in the libata ALi
> > driver?
> 
> The short answer is that "Alan Cox says not in libata", the longer
> one can be found:
> 
> http://www.archivum.info/linux-ide@vger.kernel.org/2008-07/msg00410.html

Thanks for the reference.  I've now read that thread.  I'm not entirely
convinced Alan is right; I think it's preferable to confine this
quirking to the driver and fix up the BARs in the driver as well.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
