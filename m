Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbXFDMma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbXFDMma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXFDMmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:42:23 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:55514 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXFDMmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:42:22 -0400
Date: Mon, 4 Jun 2007 13:20:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Message-ID: <20070604122054.GB26615@srcf.ucam.org>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl> <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604104621.GB4405@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: A kexec approach to hibernation
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 12:46:21PM +0200, Pavel Machek wrote:

> sync is perfectly safe way of telling the fs to store data on disk.

On disk, yes. On the filesystem, no. It's valid for the data to be left 
in the journal, for instance.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
