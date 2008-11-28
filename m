Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYK1OLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYK1OLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 09:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYK1OLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 09:11:21 -0500
Received: from styx.suse.cz ([82.119.242.94]:48324 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752167AbYK1OLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 09:11:21 -0500
Date: Fri, 28 Nov 2008 15:11:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Scholz <Scholz@fias.uni-frankfurt.de>
cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       "J.R. Mauro" <jrm8005@gmail.com>,
       Tobias Mueller <Tobias_Mueller@twam.info>
Subject: Re: [PATCH 0/1] HID: hid_apple is not used for apple alu wireless
 keyboards
In-Reply-To: <1227710025-23592-1-git-send-email-Scholz@fias.uni-frankfurt.de>
Message-ID: <alpine.LNX.1.10.0811281509450.19853@jikos.suse.cz>
References: <1227710025-23592-1-git-send-email-Scholz@fias.uni-frankfurt.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Jan Scholz wrote:

> While parsing 'hid_blacklist' in hid-core.c my apple alu wireless
> keyboard is not found.  This happens because in the blacklist it
> is declared with HID_USB_DEVICE although the keyboards are really
> bluetooth devices.  The same holds for 'apple_devices' list in
> hid-apple.c
> This patch fixes it by changing HID_USB_DEVICE to
> HID_BLUETOOTH_DEVICE in those two lists.

OK, I have done some googling in addition to what Tobias and J.R. have 
written, and your patch seems to be indeed the correct thing to do for 
these three product IDs. So I have queued it in my tree for 2.6.28, 
thanks.

-- 
Jiri Kosina
SUSE Labs
