Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab0CHRlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:41:46 -0500
Received: from ppp173-197.broadband.gorge.net ([209.216.173.197]:33513 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136Ab0CHRll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:41:41 -0500
Date: Mon, 8 Mar 2010 17:40:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial: Fix usb serial console open/close
 regression
Message-ID: <20100308174027.59284ba4@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1003081028400.1596-100000@iolanthe.rowland.org>
References: <1268061698-9846-1-git-send-email-jason.wessel@windriver.com>
	<Pine.LNX.4.44L0.1003081028400.1596-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.7; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a little unfortunate.  It would be better to prevent
> tty_port_shutdown() from clearing ASYNCB_INITIALIZED in the first
> place.  The problem is that the tty core doesn't know when the port is
> being used as a console.  There ought to be a way to tell it.

Agreed - there should probably be a port.console flag to push it up into
the tty_port logic as well.

Alan
