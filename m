Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYHSUE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYHSUE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYHSUEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:04:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56225 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753037AbYHSUEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:04:45 -0400
Date: Tue, 19 Aug 2008 16:04:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: juanslayton@dslextreme.com, Aivils Stoss <aivils@latnet.lv>,
       <jkosina@suse.cz>, lud <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
       <linuxconsole-dev@lists.sourceforge.net>, <linux-input@vger.kernel.org>
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
In-Reply-To: <681431.40736.qm@web82201.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.0808191603350.3391-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, David Brownell wrote:

> The OHCI scheduling is pretty simple and compact.  I'd think it would
> be easy enough to make UHCI do the same sort of thing:  track bandwidth
> assigned to 2^N frames (OHCI hardware imposes a smaller limit for N
> than UHCI hardware does), and pick the least loaded of those frames to
> use for new transfers.  In ohci-q.c see balance(), periodic_{,un}link().
> 
> Thing is that would involve changing how UHCI manages periodic transfers;
> assuming it hasn't changed those structures since last I looked.

Yes.  That's the messy part; the scheduling itself is easy.

Alan Stern

