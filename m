Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZAHIt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZAHIt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZAHItU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:49:20 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:42381 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZAHItT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:49:19 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression] USB wakeup problem on Toshiba Portege R500
Date: Thu, 8 Jan 2009 09:49:33 +0100
User-Agent: KMail/1.9.10
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>
References: <200901080835.39639.rjw@sisk.pl>
In-Reply-To: <200901080835.39639.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901080949.34339.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thursday 08 January 2009 08:35:39 schrieb Rafael J. Wysocki:
> Hi Alan,
> 
> Unfortunately, the following commit:
> 
> commit 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Wed Dec 17 17:20:38 2008 -0500
> 
>     USB: automatically enable wakeup for PCI host controllers
> 
>     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> causes a regression to appear on my Toshiba Portege R500.
> 
> The regression is that when suspended to RAM, the box wakes up immediately
> unless 'disabled' is written into the /sys/devices/.../power/wakeup file of the

Even without attached devices?

> EHCI controller.  I know of at least 10 different boxes out there that are
> going to have similar problems forcing their users to use manual workaround.
> 
> Also, it wakes up on a USB mouse activity, which I don't want it to do, so in
> fact I have to write 'disabled' to the /sys/devices/.../power/wakeup files of
> all USB controllers.

We do support remote wakeup from PS2 keyboards. So you might argue we
should do the same for USB HID devices.

	Regards
		Oliver


