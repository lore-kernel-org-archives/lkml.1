Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbYJ0QxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbYJ0QxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYJ0QxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:53:15 -0400
Received: from os.eurotux.com ([216.75.63.6]:34753 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYJ0QxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:53:14 -0400
Date: Mon, 27 Oct 2008 16:53:06 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
Message-ID: <20081027165306.GA3875@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux-Kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	SCSI development list <linux-scsi@vger.kernel.org>
References: <20081027151818.GA4044@bit.office.eurotux.com> <Pine.LNX.4.44L0.0810271134530.15462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0810271134530.15462-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 11:38:13AM -0400, Alan Stern wrote:
> On Mon, 27 Oct 2008, Luciano Rocha wrote:
> 
> > Hm, where in the code can I change it to return less that what it thinks
> > is the last sector?
> 
> I can write a patch to do that for you.  However I'm more interested in 
> solving the "infinite-retry" problem first.
> 
> I did write some patches which might help.  They weren't meant as bug 
> fixes exactly, more as infrastructure cleanup.  But you ought to try 
> them out, because they do affect the logic in this area.
> 
> The patches are here:
> 
> 	http://marc.info/?l=linux-scsi&m=122443015406309&w=2
> 
> They are based on 2.6.27, not 2.6.28-rc.

I've tested them (on 2.6.27.4), but I still get the bug. That email mentions:
"Neither patch addresses the infinite-retry problem; I wanted
to keep the issues separate."

So am I missing some other patch?

2.6.28-rc2 is also buggy.

Thanks,
Luciano Rocha

-- 
Luciano Rocha <luciano@eurotux.com>
Eurotux Informática, S.A. <http://www.eurotux.com/>
