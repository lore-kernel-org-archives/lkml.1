Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZFDUhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZFDUhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZFDUhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:37:06 -0400
Received: from kroah.org ([198.145.64.141]:53926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZFDUhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:37:05 -0400
Date: Thu, 4 Jun 2009 13:10:13 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Linux Driver Project Status Report as of June 2009
Message-ID: <20090604201013.GB16252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linux Driver Project Status Report as of June 2009

The Linux Driver Project (LDP) is now over two years old.  It sprang up
out of the complaints from some users and companies that there was a
real "Linux driver problem".  The perception was that Linux did not have
good driver support, and that closed source drivers were potentially
taking over some device types.

It turns out, that almost all hardware is currently already supported on
Linux, with almost all major vendors shipping Linux drivers.

So last year, I proposed the following goals:
  1) Continue to write new drivers for any company that wishes to have
     them developed.  These drivers are all to be released under the
     GPLv2 and included in the main Linux kernel source tree hosted at
     kernel.org.  Future maintenance of these drivers will be done either
     by members of the original company, or by the community members,
     depending on the wishes of the company.
  2) Continue to be a focal point for companies to learn about the Linux
     development process and become part of the kernel community if they
     wish to.  I hope to enlist more people to help out with this
     process, but if not, my airline miles logged will continue to
     increase.
  3) Work more in an open development manner, hosting all experimental
     and development code in a public git tree, getting daily testing in
     the linux-next tree on all architectures.


Goal one (write drivers) has been very successful.  Myself and many
other members of the LDP have written new drivers for a wide range of
different hardware devices, and gotten them merged into the main kernel
tree.  Several more are currently under development and we are averaging
about 2 querys a month for different drivers from different companies.

This work will continue to happen in the following year, as everyone
involved seems to be happy with it.  However, there will be a few
procedural changes in how this is working, to help resolve some of the
issues that have occurred.  For more details about this, see the
discussion on the LDP development mailing list.


Goal two (educate people) has been reasonably successful.  While working
with many companies, we have helped them become maintainers of their own
codebases within the kernel, integrating them into the main kernel
development process, allowing themself to control their drivers and
direction for their Linux support much easier.  However the need for
training on how to do this kind of development, and even just basic
Linux kernel development skills is in very high demand.  Hopefully
through the new Linux Foundation effort of providing training, this need
can be met.  Although I still expect myself and other members of the LDP
to continue to travel and speak about this topic.


Goal three (work in the open) has succeeded even better than I had
expected.  At the Linux Kernel Summit last year, the drivers/staging/
tree was created, allowing us a place within the main Linux kernel tree
for drivers to be merged that were not yet of the high kernel quality
standards.  This has allowed many users the ability to use their
hardware with Linux much earlier than previously possible, and it has
allowed a common place for the community to contribute patches and fixes
for these drivers.  This has aliviated the need to hunt over the
internet for various drivers.

The staging tree has also provided a place for developers wishing to get
into Linux kernel development to easily help out and start working on
code.  Often times it is only the lack of knowing what to work on that
keeps many people from participating in kernel development.  This
portion of the kernel tree provides ample opportunities for people to
help out with.


So, what is next for the LDP?  As the previous three goals worked so
well this past year, I propose just continuing them in the following
manner:
  - We will work with any company that wishes to have Linux kernel
    drivers written for them, doing the work, for free, and merging the
    result into the mainline kernel tree.
  - We will work with any company that wishes to have us work to merge
    their existing Linux kernel drivers into the main kernel tree.
  - We will maintain the staging tree, containing "pre-mergable" code,
    to provide a centralized point for users to use new hardware sooner,
    and for developers to be able to join the kernel community.
  - We will work on education and training of companies and developers
    about how the Linux kernel development process works, and help them
    achive the technical knowledge to participate fully within it.


Thanks

I'd first like to thank my employer, Novell, for giving me the
opportunity to work on this project full time.  Their acceptance and
support for the LDP is amazing and has been what has allowed it to
survive and produce such great results.

I'd also like to thank all of the developers who have offered to help
out with this project.  Your volunteering to participate is amazing and
shows the strength of the Linux developer community.

I'd also like to thank Tomasz Grzegurzko for maintaining and keeping the
linuxdriverproject.org domain and server up and running so well.  Also
thanks to the OSU Open Source Labs for your domain and bandwidth support
of the project.
