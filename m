Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZBAPxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZBAPxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 10:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZBAPxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 10:53:35 -0500
Received: from kroah.org ([198.145.64.141]:60301 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752064AbZBAPxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 10:53:34 -0500
Date: Sun, 1 Feb 2009 07:51:17 -0800
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: wgreathouse@smva.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] usb-serial : fix the nousb oops
Message-ID: <20090201155117.GA10018@kroah.com>
References: <49857F23.3090208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49857F23.3090208@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 01, 2009 at 06:53:23PM +0800, Dave Young wrote:
> 
> In case with "nousb" booting, serial drivers will trigger kernel oops.

They will?  What is the oops message?

> Here add usb_disabled() check in usb_serial_init and usb_serial_register

This is odd, is it something new?  Why is usb-serial the only driver
that needs such a thing?

confused,

greg k-h
