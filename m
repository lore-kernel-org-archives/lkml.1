Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbYGOUZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbYGOUZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbYGOUZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:25:21 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37371 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbYGOUZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:25:20 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807151316180.2867@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <1216149637.27242.65.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
	 <1216150616.27455.377.camel@shinybook.infradead.org>
	 <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
	 <1216151866.26991.4.camel@shinybook.infradead.org>
	 <1216152609.27242.99.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151316180.2867@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 22:25:29 +0200
Message-Id: <1216153529.27242.116.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > So Ubuntu will obviously not break since it does this already. For
> > Fedora deploying new packages for 8 and 9 should not be a problem at all
> > once the maintainer is convinced that it is a good idea. They update
> > packages all the time anyway. For the other distros, I don't know.
> 
> Umm. Again, Marcel. We don't require new user land to work.
> 
> But just loading the thing on our own does solve this problem. But udev we 
> simply cannot require people to magically have a new version of.

we might have to do a step by step upgrade for this. Something like
install everything in /lib/firmware/`uname -r`/ and create symlinks for
a grace period of the next sixt month or something like this.

These are details that have be sorted out, but should not stop us to get
this right.

And before you say anything. You can expect that firmware loading
from /lib/firmware works almost everywhere. At least this has been for
the last 3 years or so. Remember that we do have request_firmware() even
in the latest 2.4 kernels.

Regards

Marcel


