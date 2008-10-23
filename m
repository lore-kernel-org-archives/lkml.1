Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYJWXkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYJWXkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJWXj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:39:59 -0400
Received: from mx1.suse.de ([195.135.220.2]:60692 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYJWXj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:39:58 -0400
Date: Thu, 23 Oct 2008 16:36:19 -0700
From: Greg KH <gregkh@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbcore: Limit number of 'unable to enumerate USB
	device' messages
Message-ID: <20081023233619.GA21531@suse.de>
References: <49010A25.6020702@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49010A25.6020702@lwfinger.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 04:35:01PM -0700, Larry Finger wrote:
> In my system, a number of messages that state "unable to enumerate USB device"
> are logged. These are intermittent and likely due to some race condition
> at bootup.
> 
> Some of these happen when the EHCI driver is loaded after UHCI or OHCI, which
> causes the device to be switched away from the other controller that's trying
> to enumerate it, at least momentarily. This type of message is logged at most
> once for each hub and occurs in about 70% of my reboots.

What kernel version are you having these problems with?

thanks,

greg k-h
