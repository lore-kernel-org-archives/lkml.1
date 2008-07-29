Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYG2Vy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYG2Vy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYG2VyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:54:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43776 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYG2VyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:54:12 -0400
Message-ID: <488F917B.2050800@garzik.org>
Date: Tue, 29 Jul 2008 17:54:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>,
       linux-kernel@vger.kernel.org, Martin Petersen <mkp@mkp.net>,
       Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: tools support for non-512 byte sector sizes
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org>
In-Reply-To: <20080729182611.GB24924@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Jul 29, 2008 at 01:24:31PM -0400, Ric Wheeler wrote:
>> Jim pinged me about the use case for having our tool chain (parted 
>> specifically) support devices with non-512 bytes sectors.
> 
> Matt Domsch spoke with me about this at OLS.  I took that opportunity,
> and I'll take this one, to pimp my ata-ram driver which allows you to
> alter the sector sizse to whatever you want:
> 
> http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=ata-ram
> 
> I'll admit to having not tested it with anything other than 512, but it
> ought to support 4096 byte sectors just fine.  I haven't looked at what
> would be required to support 520-byte sectors.
> 
> Jeff, any interest in merging ata-ram soon?  I've got some users inside
> Intel, and Zab persuaded me to add the multiple port support last night,
> so it's not just useful for me.  I think it's also a nice template to
> have around to show how to write a minimal libata driver.

I'm happy to include ata_ram whenever it is working and you think it's 
ready for inclusion.

	Jeff



