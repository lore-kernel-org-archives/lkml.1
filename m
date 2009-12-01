Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZLAQW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZLAQW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZLAQW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:22:57 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46662 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753973AbZLAQW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:22:56 -0500
Date: Tue, 1 Dec 2009 11:23:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: linux-next@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: usb tree build warning
In-Reply-To: <20091130170128.db346120.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.44L0.0912011122060.2983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Stephen Rothwell wrote:

> Hi Greg,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_suspend':
> drivers/net/wimax/i2400m/usb.c:595: warning: unused variable 'usb_dev'
> 
> Introduced by commit a85c653a3945350875611d3cb071a0143cfeb2d2 ("USB:
> remove the auto_pm flag") which removed the last usage in this function.

Greg, can you fix this?  Simply modify the patch to eliminate the 
unused local variable and the enclosing #ifdef.

Thanks,

Alan Stern

