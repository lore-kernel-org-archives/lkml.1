Return-Path: <linux-kernel-owner+w=401wt.eu-S1763618AbXJZPoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763618AbXJZPoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbXJZPob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:44:31 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:46720 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbXJZPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:44:30 -0400
Date: Fri, 26 Oct 2007 17:47:06 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20071026154705.GY19019@enneenne.com>
References: <20071026105125.GA28769@enneenne.com> <20071026151141.GA4321@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026151141.GA4321@flint.arm.linux.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] PCMCIA: prevent auto insert during resume.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 04:11:41PM +0100, Russell King wrote:
> On Fri, Oct 26, 2007 at 12:51:25PM +0200, Rodolfo Giometti wrote:
> > If a socket has been ejected before sleeping, at resume time it
> > shouldn't be awaked.
> 
> Conversely, if a card has been inserted into an empty slot prior to
> resuming, it should be detected.  Removing this check prevents that
> happening, which sucks for at least embedded devices.

You can use "pccardctl insert" to do it. :)

On battery powered device I should prevent power lost, so if I power
down a device I'd like it should remain off even after resume.

Why the system should power it on automagically? Just for detection?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
