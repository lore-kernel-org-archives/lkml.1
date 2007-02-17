Return-Path: <linux-kernel-owner+w=401wt.eu-S1946364AbXBQBiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946364AbXBQBiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 20:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946367AbXBQBiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 20:38:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:50725 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1946364AbXBQBiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 20:38:20 -0500
X-Provags-ID: V01U2FsdGVkX1/qHj8Tce3qopxyYHq7+UyAQaJylLGy2+VV7lchgX
	QZVg==
Subject: Re: 2.6.20.git regression: 'PCI: add the sysfs driver name to all
	modules' causes hard hang on boot
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070216223609.GA6165@kroah.com>
References: <1171619710.6828.24.camel@Homer.simpson.net>
	 <20070216223609.GA6165@kroah.com>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 02:38:08 +0100
Message-Id: <1171676288.6448.9.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 14:36 -0800, Greg KH wrote:
> On Fri, Feb 16, 2007 at 10:55:10AM +0100, Mike Galbraith wrote:
> > Greetings,
> > 
> > Per $subject, git.yesterday hangs hard on boot here. A git bisect
> > fingered the commit below, which I verified via git bisect reset; git
> > revert -n 725522b5453dd680412f2b6463a988e4fd148757, after which box
> > boots fine.  (well, I hope I verified... i'm git-ignorant)
> 
> If you change CONFIG_SYSFS_DEPRECATED to Y, does that solve the problem?

It's already set.

> If not, can you press alt-sysrq-T and send us the list of the tasks so
> that we can try to figure out what is hanging here?

Box is ding-dong-dead.

I'll fiddle with it.  (pretty darn innocuous looking change...)

	-Mike

