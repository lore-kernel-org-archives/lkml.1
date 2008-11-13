Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYKMWMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYKMWMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYKMWMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:12:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46226 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYKMWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:12:40 -0500
Date: Thu, 13 Nov 2008 23:22:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andi Kleen <andi@firstfloor.org>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: don't grab devices with no input
Message-ID: <20081113222200.GD3810@one.firstfloor.org>
References: <Pine.LNX.4.44L0.0811131632150.3036-100000@iolanthe.rowland.org> <491CA495.7010007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491CA495.7010007@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 11:05:09PM +0100, Jiri Slaby wrote:
> On 11/13/2008 10:37 PM, Alan Stern wrote:
> >> +	for (n = 0; n < interface->desc.bNumEndpoints; n++)
> >> +		if (usb_endpoint_dir_in(&interface->endpoint[n].desc))
> >> +			has_in++;
> >> +	if (!has_in) {
> >> +		dev_err(&intf->dev, "couldn't find an input interrupt "
> >> +				"endpoint");
> >> +		return -ENODEV;
> >> +	}
> >> +
> > 
> > Do you want to use usb_endpoint_is_int_in() instead?  It matches the 
> > error message more closely.
> 
> Yes, good catch, thanks.
Should I test it with that change or the original version?

-Andi

-- 
ak@linux.intel.com
