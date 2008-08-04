Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbYHDPVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbYHDPVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYHDPV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:21:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45915 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbYHDPV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:21:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] [PM] Fixes missing PM entries in sysfs without CONFIG_PM_SLEEP
Date: Mon, 4 Aug 2008 17:24:22 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Dasgupta, Romit" <romit@ti.com>, David Engraf <david.engraf@netcom.eu>,
       Greg KH <greg@kroah.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0808041112580.2815-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808041112580.2815-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808041724.24016.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 4 of August 2008, Alan Stern wrote:
> On Mon, 4 Aug 2008, Rafael J. Wysocki wrote:
> 
> > > Rafael, any objections?
> > 
> > Hm, well, one thing below.
> 
> > device_pm_add() can now be void and the error variable in there is not
> > necessary any more.
> 
> Do you think we will want to make device_pm_add() return an error at 
> some point in the future?

Well, maybe, but not any time soon. :-)

> For example, earlier you had it fail if the parent device was asleep, instead
> of just printing a warning. 

Yes, I remeber it, but there still are some drivers that would break if we
did that.

Anyway, I think it won't be hard to change device_pm_add() to return error
codes again if we decide to in future.

Thanks,
Rafael
