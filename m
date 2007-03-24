Return-Path: <linux-kernel-owner+w=401wt.eu-S1750994AbXCXVZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbXCXVZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 17:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXCXVZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 17:25:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60293 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbXCXVZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 17:25:21 -0400
Date: Sat, 24 Mar 2007 14:22:53 -0700
From: Greg KH <greg@kroah.com>
To: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>
Cc: linux-usb-devel@lists.sourceforge.net, usagi-core@linux-ipv6.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] [PATCH 0/2] [SERIAL] [USB] fixed to skip NULL entry in struct serial usb_serial_port.
Message-ID: <20070324212253.GA26215@kroah.com>
References: <20070325.005227.432838064.takamiya@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325.005227.432838064.takamiya@linux-ipv6.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 12:52:27AM +0900, Noriaki TAKAMIYA wrote:
> Hi,
> 
>   When I boot using linux-2.6.21-rc4 on ThinkPad T41 with pl2303 USB
>   serial device plugged in, the kernel crashes.
> 
>   The reason is struct usb_serial_port is referenced without checking
>   whether it is NULL or not.

This should already be fixed in the -git snapshots that have come out
after 2.6.21-rc4.  Can you test them to verify this?

thanks,

greg k-h
