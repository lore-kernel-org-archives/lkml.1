Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbXI1Tsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbXI1Tsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXI1Tsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:48:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbXI1Tso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:48:44 -0400
Message-ID: <46FD5A94.1010306@redhat.com>
Date: Fri, 28 Sep 2007 15:48:36 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Chris Frey <cdfrey@foursquare.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Temporarily disabling CONFIG_USB_SUSPEND
References: <20070928194251.GA7666@foursquare.net>
In-Reply-To: <20070928194251.GA7666@foursquare.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2007 03:42 PM, Chris Frey wrote:
> Hi,
> 
> Is there a global means to disable the CONFIG_USB_SUSPEND feature, perhaps
> through /proc or /sysfs?
> 
> I know this can be done, in a semi-reliable manner, on a per-device
> basis by writing 0 or 2 to the /sys/.../device/power/state file, but
> I'm looking for something that will have the same effect as disabling
> CONFIG_USB_SUSPEND, but without recompiling the kernel.
> 

Kernel boot option usbcore.autosuspend=-1 if usbcore is built-in.

# modprobe usbcore autosuspend=-1

(0 now means suspend immediately)
