Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYEENpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYEENpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYEENpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:45:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60028 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbYEENo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:44:59 -0400
Date: Mon, 5 May 2008 15:45:48 +0200
From: Pavel Machek <pavel@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jean Delvare <khali@linux-fr.org>, Kasper Sandberg <lkml@metanurb.dk>,
       Rudolf Marek <r.marek@assembler.cz>,
       Maxim Levitsky <maximlevitsky@gmail.com>, trenn@suse.de,
       Len Brown <lenb@kernel.org>, Matthew <jackdachef@gmail.com>,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Message-ID: <20080505134548.GB5351@elf.ucw.cz>
References: <200804231143.10875.maximlevitsky@gmail.com> <1209406784.11608.15.camel@localhost> <1209474423.1784.837.camel@queen.suse.de> <20080429170824.09540206@hyperion.delvare> <48179DB4.8040701@assembler.cz> <1209514274.27499.12.camel@localhost> <20080430082005.4b76186f@hyperion.delvare> <20080430145110.GC3543@khazad-dum.debian.net> <20080502203615.GF3956@ucw.cz> <20080504174229.GA29118@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504174229.GA29118@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-05-04 14:42:29, Henrique de Moraes Holschuh wrote:
> On Fri, 02 May 2008, Pavel Machek wrote:
> > > Actually, just libsensors would, and the local admin can adjust it at
> > > will using the config file.
> > > 
> > > Nobody in userspace should be reading hwmon sysfs directly without the
> > > use of libsensors.  If they are, it is their bug, and it is unsupported
> > > AFAIK.
> > 
> > Hmm, that's an interesting ABI design. No, I do not think that's a
> > good idea.
> 
> That's how it is.  The kernel drivers are to attempt to do their best to
> give proper readings.  But if they don't, the library can apply
> arbritary user-configurable adjustments.
> 
> I'd rather different attribute names like "raw_temp#" were used when the
> adjustment thorugh libsensors is *required*, though.

Yes, that would be nice.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
