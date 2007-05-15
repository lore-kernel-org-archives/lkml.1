Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbXEOR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbXEOR3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbXEOR3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:29:10 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59438 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbXEOR3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:29:08 -0400
Date: Tue, 15 May 2007 11:29:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: James Bottomley <james.bottomley@steeleye.com>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org
Subject: Re: Asynchronous scsi scanning
Message-ID: <20070515172905.GJ10562@parisc-linux.org>
References: <1179073116.3723.45.camel@mulgrave.il.steeleye.com> <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com> <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com> <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com> <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com> <1179153096.3703.23.camel@mulgrave.il.steeleye.com> <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com> <17841.simon.1179228389@5ec7c279.invalid> <20070515120228.GI10562@parisc-linux.org> <4649E03A.1090004@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4649E03A.1090004@simon.arlott.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 05:30:50PM +0100, Simon Arlott wrote:
> On 15/05/07 13:02, Matthew Wilcox wrote:
> >It's easy to suggest a sysfs attribute.  What you've failed to do is
> >suggest the pathname of the sysfs attribute, the contents of it, or the
> >semantics of it (read-only?  read-write?  write-only?  blocking?)
> 
> I would assume that should be up to SCSI users/maintainer(s). The only 
> thing I use the SCSI driver for is usb-storage/ATAPI.

Then you're not so much "suggesting a sysfs attribute" as whining.

> >I'd *really* like to hear from distro people.  What is the most
> >convenient way for you to implement "load all the scsi modules, then
> >wait until all devices are found"?  James and I had thought that loading
> >a new module would be the easiest way for you, but it seems inconvenient
> >for you.
> 
> It's inconvenient for people who *don't* use it to be unable to stop the 
> module being built and installed.

Why?  You're not forced to load the module.  In what way does it
inconvenience you?  Nobody's making you run 'make modules_install'.
I often forget to myself.
