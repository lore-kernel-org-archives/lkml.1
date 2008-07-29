Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYG2Sm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYG2Sm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbYG2Smq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:42:46 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45793 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbYG2Smo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:42:44 -0400
Date: Tue, 29 Jul 2008 12:42:43 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>,
       linux-kernel@vger.kernel.org, Martin Petersen <mkp@mkp.net>,
       Jeff Garzik <jeff@garzik.org>, Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: tools support for non-512 byte sector sizes
Message-ID: <20080729184243.GC24924@parisc-linux.org>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217356645.6103.48.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 01:37:25PM -0500, James Bottomley wrote:
> scsi_debug does exactly the same thing, so it reports anything you tell
> it (Martin Petersen actually added this so he could test with 4k
> sectors).
> 
> The problem, which ata_ram also suffers, is that the tools we most need
> to test are the ones for manipulating non volatile characteristics (like
> partition tables).  We'd really like the disk contents to survive reboot
> for this ...

Ummm... _reboot_, or _module unload/reload_?  I could certainly include
an option to populate the ramdisc from a file.  Is the ioctl to re-read
the partition table not enough?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
