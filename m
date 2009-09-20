Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZITPKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZITPKB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 11:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZITPKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 11:10:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:59547 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZITPKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 11:10:00 -0400
Date: Sun, 20 Sep 2009 08:05:49 -0700
From: Greg KH <greg@kroah.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone
	VPA-II" ?
Message-ID: <20090920150549.GC11621@kroah.com>
References: <4AB630AD.90207@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB630AD.90207@imap.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 03:39:57PM +0200, Tilman Schmidt wrote:
> When I connect my "T-Mobile MDA compact III" to my PC, running
> kernel 2.6.31 with openSUSE 10.3 userspace, I get exactly the
> symptoms described in:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8094
> 
> But that bug is marked as "CLOSED CODE_FIX", though reading through
> the comments I found no clear indication what was actually fixed,
> and from reading through the source files drivers/usb/serial/ipaq.c
> and drivers/usb/serial/usb-serial.c I get the impression that the
> problem of ipaq_open() oopsing because it gets called with
> port->read_urb==NULL is still present.
> 
> So can someone tell me what is the status of this bug?

"Closed"  :)

Can you provide a log message that shows the problem you are having with
the 2.6.31 kernel?

thanks,

greg k-h
