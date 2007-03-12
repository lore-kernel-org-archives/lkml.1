Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbXCLUsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbXCLUsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXCLUsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:48:18 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1341 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbXCLUsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:48:18 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.21-rc3-mm1
Date: Mon, 12 Mar 2007 21:50:43 +0100
User-Agent: KMail/1.9.5
Cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0703101359550.7545-100000@patience.localdomain>
In-Reply-To: <Pine.LNX.4.44L0.0703101359550.7545-100000@patience.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122150.44549.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

> > Any thoughts?
> 
> Another mistake on my part.  The correct command is
> 
> 	echo -n '2-2:1.0' >/sys/bus/usb/drivers/usbhid/unbind
> 
> Without the "-n", the system thinks that the newline character at the end 
> of the line written by "echo" is part of the filename.

Nice tip. Thanks. I've run some tests and as expected -> no failure so far.



Regards,

	Mariusz Kozlowski
