Return-Path: <linux-kernel-owner+w=401wt.eu-S1946486AbXBQIUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946486AbXBQIUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 03:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946489AbXBQIUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 03:20:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:38691 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1946486AbXBQIUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 03:20:13 -0500
X-Provags-ID: V01U2FsdGVkX19GZkYPFoJGZpFAmrcI7dhUWmWQSvnC60+PixA1Jh
	g+Kg==
Subject: Re: 2.6.20.git regression: 'PCI: add the sysfs driver name to all
	modules' causes hard hang on boot
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070217015048.GB18591@kroah.com>
References: <1171619710.6828.24.camel@Homer.simpson.net>
	 <20070216223609.GA6165@kroah.com>
	 <1171676288.6448.9.camel@Homer.simpson.net>
	 <20070217015048.GB18591@kroah.com>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 09:20:01 +0100
Message-Id: <1171700401.6443.16.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 17:50 -0800, Greg KH wrote:
> On Sat, Feb 17, 2007 at 02:38:08AM +0100, Mike Galbraith wrote:
> > On Fri, 2007-02-16 at 14:36 -0800, Greg KH wrote:
> > > On Fri, Feb 16, 2007 at 10:55:10AM +0100, Mike Galbraith wrote:
> > > > Greetings,
> > > > 
> > > > Per $subject, git.yesterday hangs hard on boot here. A git bisect
> > > > fingered the commit below, which I verified via git bisect reset; git
> > > > revert -n 725522b5453dd680412f2b6463a988e4fd148757, after which box
> > > > boots fine.  (well, I hope I verified... i'm git-ignorant)
> > > 
> > > If you change CONFIG_SYSFS_DEPRECATED to Y, does that solve the problem?
> > 
> > It's already set.
> 
> It's not set in the config file you sent to me and the list :)

Oops.  (Lysdexic mouse, or friends+Aerosmith+beer+2:30A.M.:) Makes no
difference.  Nada from nmi_watchdog either btw.

	-Mike

