Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbZJHUjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbZJHUjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759663AbZJHUjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:39:31 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53292 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbZJHUjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:39:31 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Date: Thu, 8 Oct 2009 22:40:36 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0910081601350.2765-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910081601350.2765-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910082240.36607.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 8. Oktober 2009 22:06:10 schrieb Alan Stern:

>
> On further thought, unthrottle should autoresume if the device is
> open and autosuspended (but it shouldn't do anything if the device is
> suspended).  After all, the reason for the autosuspend may have been
> the lack of activity caused by the throttling.
>
> In practice this isn't likely to come up.  It would be surprising if
> throttling lasted long enough to cause an autosuspend or if the core
> decided to throttle while the device was autosuspended and hence idle.

So you say that throttle() should do an autopm_put?

	Regards
		Oliver

