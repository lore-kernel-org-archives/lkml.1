Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbXFDNQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbXFDNQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXFDNQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:16:34 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:44615 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbXFDNQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:16:33 -0400
Date: Mon, 4 Jun 2007 14:16:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Message-ID: <20070604131624.GA27565@srcf.ucam.org>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl> <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz> <20070604122054.GB26615@srcf.ucam.org> <20070604131000.GD1971@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604131000.GD1971@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: A kexec approach to hibernation
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 03:10:00PM +0200, Pavel Machek wrote:
> On Mon 2007-06-04 13:20:54, Matthew Garrett wrote:
> > On Mon, Jun 04, 2007 at 12:46:21PM +0200, Pavel Machek wrote:
> > 
> > > sync is perfectly safe way of telling the fs to store data on disk.
> > 
> > On disk, yes. On the filesystem, no. It's valid for the data to be left 
> > in the journal, for instance.
> 
> Yep... then grub needs to grok the journal. It does for ext3, IIRC.

No, it only supports ext2 (and reading ext3 as if it's ext2). Right now, 
the assumption that syncing during suspend will cause data to hit 
something grub can read isn't a safe one.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
