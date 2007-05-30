Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbXE3NIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbXE3NIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXE3NIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:08:42 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:35594 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXE3NIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:08:41 -0400
Date: Wed, 30 May 2007 13:40:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <20070530124027.GA27942@srcf.ucam.org>
References: <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org> <1180059605.3997.100.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org> <1180062040.3997.112.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org> <1180067587.3997.136.camel@nigel.suspend2.net> <465C366C.2070900@rtr.ca> <1180473765.20718.47.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705291428410.26602@woody.linux-foundation.org> <20070530114920.GB26326@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530114920.GB26326@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 01:49:21PM +0200, Pavel Machek wrote:

(Trimmed the Cc:s quite heavily - I think this has gone somewhere beyond 
the original point)

> Notice that we want to be able to suspend while hibernating -- for
> suspend to both behaviour. So drivers may _not_ rely on system being
> runnable.

So keep the driver layers read-only and unfreeze the processes after 
doing the atomic copy.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
