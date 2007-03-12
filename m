Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbXCLUun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbXCLUun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbXCLUun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:50:43 -0400
Received: from styx.suse.cz ([82.119.242.94]:36401 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752905AbXCLUum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:50:42 -0400
Date: Mon, 12 Mar 2007 21:53:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] 2.6.21-rc3-mm1
In-Reply-To: <200703122150.44549.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.64.0703122152110.10121@jikos.suse.cz>
References: <Pine.LNX.4.44L0.0703101359550.7545-100000@patience.localdomain>
 <200703122150.44549.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Mariusz Kozlowski wrote:

> > 	echo -n '2-2:1.0' >/sys/bus/usb/drivers/usbhid/unbind
> > Without the "-n", the system thinks that the newline character at the end 
> > of the line written by "echo" is part of the filename.
> Nice tip. Thanks. I've run some tests and as expected -> no failure so far.

Thanks for testing. The patch fixing this already went to Linus in todays 
HID/USB HID update (which has not yet been merged).

Thanks,

-- 
Jiri Kosina
