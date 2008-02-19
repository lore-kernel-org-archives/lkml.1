Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbYBSUDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbYBSUDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYBSUD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:03:26 -0500
Received: from styx.suse.cz ([82.119.242.94]:60523 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751971AbYBSUD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:03:26 -0500
Date: Tue, 19 Feb 2008 21:03:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tomas Carnecky <tom@dbservice.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: hid device not claimed but /dev/input/event exists
In-Reply-To: <47BB1D9E.6030501@dbservice.com>
Message-ID: <Pine.LNX.4.64.0802192102270.30955@jikos.suse.cz>
References: <47BB041F.4060003@dbservice.com> <Pine.LNX.4.64.0802191751040.7699@twin.jikos.cz>
 <47BB1515.1070608@dbservice.com> <Pine.LNX.4.64.0802191846250.30955@jikos.suse.cz>
 <47BB1D9E.6030501@dbservice.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Tomas Carnecky wrote:

> This bug is in a completely different place then I thought! The speakers 
> were plugged into the hub built into my monitor. I plugged it directly 
> into the mainboard and voila, it works. Even g15daemon, the lcd driver, 
> can now display a nice clock on the lcd. Could it be that the hub is 
> defective?

Definitely could be.

Please collect usbmon logs (this is what you asked for previously -- the 
USB traffic analyzer -- see Documentation/usb/usbmon.txt) and send them to 
the usb-devel mailinglist. This is no longer related to HID code at all.

Thanks for tracking this down,

-- 
Jiri Kosina
SUSE Labs
