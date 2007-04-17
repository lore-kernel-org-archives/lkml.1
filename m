Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbXDQPaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbXDQPaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbXDQPaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:30:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51621 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752945AbXDQPav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:30:51 -0400
Date: Tue, 17 Apr 2007 16:33:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Tilman Schmidt <tilman@imap.cc>, Randy Dunlap <randy.dunlap@oracle.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       i4ldeveloper@listserv.isdn4linux.de, Karsten Keil <kkeil@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: so what *is* obsolete and removable?
Message-ID: <20070417163337.3b62b8f5@the-village.bc.nu>
In-Reply-To: <4624E1DE.2040300@imap.cc>
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
	<4623FB0E.4080602@imap.cc>
	<20070416161337.d59f2ea3.randy.dunlap@oracle.com>
	<4624C320.3050206@imap.cc>
	<20070417144054.24c104bf@the-village.bc.nu>
	<4624E1DE.2040300@imap.cc>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 17:03:58 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> On Tue, 17 Apr 2007 14:40:54 +0100, Alan Cox wrote:
> > If the obsolete tag is to be removed then it needs a formal maintainer,
> > all the obsolete interface usage cleaning up and the like otherwise at
> > some point in a clean up it is going to end up breaking and migrating to
> > && BROKEN as well.
> 
> I'm not sure I understand. What do you mean by "obsolete interface
> usage"? What sort of cleaning up needs to be done? What sort of
> breakage do you anticipate in the event of a clean up?

Things like:

	pci_find_device
	pci_find_bus

	interruptible_sleep_on
	sleep_on

	lock_kernel
	unlock_kernel

and the drivers that i4l uses (eg hisax) need switching to the proper
pci_module interfaces to handle hot plug.

