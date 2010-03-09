Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0CIScl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:32:41 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:22300 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0CIScj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:32:39 -0500
X-IMAP-Sender: achiang
Date: Tue, 9 Mar 2010 11:32:27 -0700
X-OfflineIMAP-x2122322631-6c646c-494e424f582e4f7574626f78: 1268159558-0998911378209-v6.2.0
From: Alex Chiang <achiang@hp.com>
To: Greg KH <greg@kroah.com>
Cc: sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] small xhci cleanups
Message-ID: <20100309183227.GD15974@grease.lan>
References: <20100309174815.29339.96173.stgit@bob.kio> <20100309181413.GB31027@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309181413.GB31027@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com>:
> On Tue, Mar 09, 2010 at 10:52:43AM -0700, Alex Chiang wrote:
> 
> >       USB: xhci: move all debug code under CONFIG_XHCI_HCD_DEBUGGING
> 
> Does this conflict with Sarah's other debugging patch she just sent out?

I'm assuming you're talking about this patch:

	http://thread.gmane.org/gmane.linux.usb.general/28681

Yes, we'll definitely have conflicts. If you agree that we should
move the debug code under the Kconfig option, then the best
course of action would be for Sarah to rebase her work on top of
my patches (since they're intrusive).

/ac

