Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbZEZVcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbZEZVcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbZEZVbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:31:46 -0400
Received: from mail.crca.org.au ([67.207.131.56]:35055 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758522AbZEZVbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:31:45 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200905261307.22664.oliver@neukum.org>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905260058.54482.rjw@sisk.pl> <20090526091940.GA29867@elf.ucw.cz>
	 <200905261307.22664.oliver@neukum.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 07:33:33 +1000
Message-Id: <1243373613.13930.61.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2009-05-26 at 13:07 +0200, Oliver Neukum wrote:
> Am Dienstag, 26. Mai 2009 11:19:40 schrieb Pavel Machek:
> 
> Hello,
> 
> > For small allocations... I still believe we should free a bit of
> > memory for s2ram so that small allocations can be done without
> > problems.
> > 									Pavel
> 
> it is essential that this work. Some subsystems, ie. USB, need to allocate
> memory to do IO. For them to work, small allocations must be possible.
> 
> Now, is this a real issue? Can most devices really save a device state?
> This capability seems to me to be limited to memory mapped IO at best.
> USB devices generally don't save and restore state but bring the device
> into the state it ought to be in, not the state it was in during resumption.

USB devices ought to be able to do _something_ though - I have a Dvico
Dual Digital 4 card that is forcing me to shutdown X, mythtv-backend,
pulse audio and lirc at the moment so that I can rmmod it while
hibernating. That ought not be necessary. I'm sure there are good
technical reasons why it is necessary at the mooment, but it shouldn't
be that way - even if it just does the bare minimum required to avoid
requiring the closing of files and the unload.

Regards,

Nigel

