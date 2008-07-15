Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYGOUKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYGOUKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYGOUKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:10:03 -0400
Received: from senator.holtmann.net ([87.106.208.187]:42487 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbYGOUKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:10:01 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Marcel Holtmann <marcel@holtmann.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <1216151866.26991.4.camel@shinybook.infradead.org>
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
Content-Type: text/plain
Date: Tue, 15 Jul 2008 22:10:09 +0200
Message-Id: <1216152609.27242.99.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> > So kernel-specific directories do make sense. As does the whole "I
> > don't want to handle the pain that is udev scripts".
> 
> I'm not violently opposed to kernel-specific directories. Ubuntu does it
> that way already, and it may well make sense. I'm not sure it's really
> necessary either, but it's an option.

then lets get the udev extension merged upstream (since it doesn't do
any harm anyway) and then install everything in /lib/firmware/`uname -r`
and see how that works out.

So Ubuntu will obviously not break since it does this already. For
Fedora deploying new packages for 8 and 9 should not be a problem at all
once the maintainer is convinced that it is a good idea. They update
packages all the time anyway. For the other distros, I don't know.

Regards

Marcel


