Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXE3Nan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXE3Nan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXE3NaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:30:20 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:58021 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbXE3NaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:30:18 -0400
Date: Wed, 30 May 2007 14:29:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <20070530132958.GA28893@srcf.ucam.org>
References: <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org> <1180062040.3997.112.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org> <1180067587.3997.136.camel@nigel.suspend2.net> <465C366C.2070900@rtr.ca> <1180473765.20718.47.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705291428410.26602@woody.linux-foundation.org> <20070530114920.GB26326@elf.ucw.cz> <20070530124027.GA27942@srcf.ucam.org> <1180531067.24891.1.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180531067.24891.1.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 11:17:47PM +1000, Nigel Cunningham wrote:

> That aside, keeping the driver layers read-only sounds more complicated
> than just freezing processes.

It's a problem that effectively has to be solved for STR anyway if 
we're going to suspend without freezing. The midlayers need to be able 
to block requests when the low-level devices are suspended, so we can 
just re-use that code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
