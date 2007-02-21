Return-Path: <linux-kernel-owner+w=401wt.eu-S1423208AbXBUWcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423208AbXBUWcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423211AbXBUWcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:32:25 -0500
Received: from peacekeeper.artselect.com ([69.18.47.2]:49365 "EHLO
	wyeth.artselect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423208AbXBUWcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:32:24 -0500
X-Greylist: delayed 1612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 17:32:24 EST
Date: Wed, 21 Feb 2007 16:05:20 -0600
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Walker <dwalker@mvista.com>, tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: Linux 2.6.21-rc1 [git bisect]
Message-ID: <20070221220520.GA20659@artselect.com>
References: <1172078340.8577.43.camel@imap.mvista.com> <1172079671.25076.80.camel@localhost.localdomain> <1172079523.8577.48.camel@imap.mvista.com> <1172081931.25076.95.camel@localhost.localdomain> <1172082200.8577.56.camel@imap.mvista.com> <1172085792.25076.119.camel@localhost.localdomain> <1172088050.8577.71.camel@imap.mvista.com> <1172090603.25076.127.camel@localhost.localdomain> <1172090973.8577.77.camel@imap.mvista.com> <Pine.LNX.4.64.0702211302300.4043@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702211302300.4043@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Pete Harlan <harlan@artselect.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 01:06:17PM -0800, Linus Torvalds wrote:
> That said, one thing to worry about when doing bisection: the kernel 
> configuration.

This bit me badly the one time I did a git bisect; it kept ping-
ponging around a big change (sata? xtables?) that required me to
answer the same two dozen questions about ten different times.

If git-bisect itself could manage .config as part of the process,
reverting to the one used with the most-recently-in-the-past try when
it backs up to a revision, that would be, you know, wonderful.

--Pete

----------------------------------
Pete Harlan
ArtSelect, Inc.
harlan@artselect.com
http://www.artselect.com
ArtSelect is a subsidiary of a21, Inc.
