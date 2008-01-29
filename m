Return-Path: <linux-kernel-owner+w=401wt.eu-S933708AbYA2SOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708AbYA2SOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759403AbYA2SMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:12:17 -0500
Received: from iabervon.org ([66.92.72.58]:47500 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbYA2SMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:12:14 -0500
Date: Tue, 29 Jan 2008 13:12:10 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Gene Heskett <gene.heskett@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Richard Heck <rgheck@bobjweil.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <20080129174455.62742b82@core>
Message-ID: <alpine.LNX.1.00.0801291252120.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com> <200801291132.41657.gene.heskett@gmail.com> <18335.22763.625990.528217@alkaid.it.uu.se> <200801291204.44671.gene.heskett@gmail.com> <alpine.LNX.1.00.0801291220540.13593@iabervon.org>
 <20080129174455.62742b82@core>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Alan Cox wrote:

> > things in the kernel that refer to SCSI probably should say "storage" (or 
> > "ATA", really, but that would make the acronyms confusing).
> 
> SCSI is a command protocol. It is what your CD-ROM drive and USB storage
> devices talk (albeit with a bit of an accent).

Among other things, yes. But SCSI standards also specify electrical 
interfaces that aren't at all related to the electrical interfaces used by 
a lot of devices, and a lot of the places the kernel uses the term suggest 
that it's also talking about the electrical interface (or, at least, 
connector shape). For example, it's misleading to talk about "SCSI CDROM 
support" meaning the command protocol when hardly anybody has ever seen a 
CDROM drive that doesn't use the SCSI command protocol, but most people 
know about both SCSI-connector and PATA-connector CDROM drives.

	-Daniel
*This .sig left intentionally blank*
