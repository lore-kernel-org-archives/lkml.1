Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbZJHWbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbZJHWbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 18:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759932AbZJHWbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 18:31:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37489 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756557AbZJHWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 18:31:12 -0400
Date: Thu, 8 Oct 2009 23:31:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Message-ID: <20091008233150.5e033c11@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0910081722340.2765-100000@iolanthe.rowland.org>
References: <200910082240.36607.oliver@neukum.org>
	<Pine.LNX.4.44L0.0910081722340.2765-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> update the last_busy time in the completion of every input URB).  When
> the driver is throttled no URBs will be submitted, so the usage count
> will remain at 0 with no effort on the part of throttle().

You can still get modem changes (set_mctrl), break etc with the port
throttled, or indeed output.

