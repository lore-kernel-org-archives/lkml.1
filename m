Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYCCMu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYCCMu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYCCMuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:50:16 -0500
Received: from styx.suse.cz ([82.119.242.94]:38911 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827AbYCCMuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:50:15 -0500
Date: Mon, 3 Mar 2008 13:50:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pekka Sarnila <sarnila@adit.fi>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] hid: quirk to fixup fullspeed interval on highspeed
 devices
In-Reply-To: <47C96DEB.5070304@adit.fi>
Message-ID: <Pine.LNX.4.64.0803031333080.15209@jikos.suse.cz>
References: <47C96DEB.5070304@adit.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Pekka Sarnila wrote:

> Many vendors highspeed devices give erroneously fullspeed interval value 
> in endpoint descriptor for interrupt endpoints. This quirk fixes up that 
> by recalculating the right value for highspeed device.

Hi Pekka,

thanks for the patch. I however think that HID code is really a wrong 
place to to this, we really want to do this in USB core instead, as that 
it where it belongs.

Why do you think that adding a new quirk for this device to 
usb/core/quirks.c and then checking for it in usb_parse_endpoint() is not 
feasible?

Thanks,

-- 
Jiri Kosina
SUSE Labs
