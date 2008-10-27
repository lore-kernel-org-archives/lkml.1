Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbYJ0PiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbYJ0PiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYJ0PiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:38:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48079 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751116AbYJ0PiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:38:15 -0400
Date: Mon, 27 Oct 2008 11:38:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Luciano Rocha <luciano@eurotux.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
In-Reply-To: <20081027151818.GA4044@bit.office.eurotux.com>
Message-ID: <Pine.LNX.4.44L0.0810271134530.15462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Luciano Rocha wrote:

> Hm, where in the code can I change it to return less that what it thinks
> is the last sector?

I can write a patch to do that for you.  However I'm more interested in 
solving the "infinite-retry" problem first.

I did write some patches which might help.  They weren't meant as bug 
fixes exactly, more as infrastructure cleanup.  But you ought to try 
them out, because they do affect the logic in this area.

The patches are here:

	http://marc.info/?l=linux-scsi&m=122443015406309&w=2

They are based on 2.6.27, not 2.6.28-rc.

Alan Stern

