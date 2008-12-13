Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYLMHzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYLMHzB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 02:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYLMHyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 02:54:54 -0500
Received: from kroah.org ([198.145.64.141]:46790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750917AbYLMHyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 02:54:53 -0500
Date: Fri, 12 Dec 2008 23:53:42 -0800
From: Greg KH <greg@kroah.com>
To: Matt Helsley <matt.helsley@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix genius pensketch 12x9 tablet
Message-ID: <20081213075342.GA11346@kroah.com>
References: <1229150548.11171.6.camel@molly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229150548.11171.6.camel@molly>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 10:42:28PM -0800, Matt Helsley wrote:
> The Genius PenSketch 12x9 tablet has a puck (labeled a
> "Tablet Mouse") in addition to a pen. Without registering a quirk
> the tablet appears to be a single input device that reports the
> wrong axis information in /proc/bus/input/devices, and sends
> incorrect events (e.g. ABS_Z instead of ABS_Y). This information
> confuses the X evdev driver and makes the device impossible to
> use.
> 
> The quirk fixes events and splits the device into multiple input
> event devices so that at least the puck is useful.
> 
> Signed-off-by: Matt Helsley <matt.helsley@gmail.com>
> ---
> NOTE: xinput lists the puck but not the pen. I've been using a
> python script to verify the contents of the events independently
> of X and, as far as I can tell, the remaining problems are in X
> itself.

I have a tablet here that I'm having troubles getting to work.  Any
chance I could get a copy of your python script so I can try to debug
what is going wrong, and if it's a X problem or a kernel issue like you
found for your device?

thanks,

greg k-h
