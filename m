Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYHDPO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYHDPO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYHDPOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:14:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33661 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754155AbYHDPOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:14:43 -0400
Date: Mon, 4 Aug 2008 11:14:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Dasgupta, Romit" <romit@ti.com>, David Engraf <david.engraf@netcom.eu>,
       Greg KH <greg@kroah.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] [PM] Fixes missing PM entries in sysfs without
 CONFIG_PM_SLEEP
In-Reply-To: <200808041703.28229.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0808041112580.2815-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008, Rafael J. Wysocki wrote:

> > Rafael, any objections?
> 
> Hm, well, one thing below.

> device_pm_add() can now be void and the error variable in there is not
> necessary any more.

Do you think we will want to make device_pm_add() return an error at 
some point in the future?  For example, earlier you had it fail if the 
parent device was asleep, instead of just printing a warning.

Alan Stern


