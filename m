Return-Path: <linux-kernel-owner+w=401wt.eu-S932863AbXBXOKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbXBXOKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 09:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932877AbXBXOKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 09:10:13 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:47902 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863AbXBXOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 09:10:12 -0500
Subject: Re: 2.6.20-almost-rc1: usb oops during resume
From: Marcel Holtmann <marcel@holtmann.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20070224115137.GA8658@elf.ucw.cz>
References: <20070224115137.GA8658@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 24 Feb 2007 15:10:37 +0100
Message-Id: <1172326237.11537.5.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> ...is it "use after free"?
> 
> Greg, could we reduce verbosity of driver model? "PM: Adding info for
> No Bus:vcs*" is not very useful.
> 
> I have some patches in bluetooth, but nothing that should really
> matter.

can you try to remove the hci_usb_close() in hci_usb_disconnect(),
because hci_unregister_dev() is calling this one anyway.

Regards

Marcel


