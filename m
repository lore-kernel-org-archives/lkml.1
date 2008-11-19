Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYKSX6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYKSX6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYKSX5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:57:51 -0500
Received: from styx.suse.cz ([82.119.242.94]:33296 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751021AbYKSX5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:57:50 -0500
Date: Thu, 20 Nov 2008 00:57:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Complete support for the new unibody macbooks
In-Reply-To: <49249CCB.7060807@euromail.se>
Message-ID: <alpine.LNX.1.10.0811200056240.19853@jikos.suse.cz>
References: <49109C91.6090207@euromail.se> <alpine.LNX.1.10.0811111835540.24889@jikos.suse.cz> <4919C979.3000501@euromail.se> <alpine.LNX.1.10.0811112347260.24889@jikos.suse.cz> <20081119113753.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.10.0811191803320.19853@jikos.suse.cz>
 <49249431.9040104@euromail.se> <alpine.LNX.1.10.0811192339560.19853@jikos.suse.cz> <49249CCB.7060807@euromail.se>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008, Henrik Rydberg wrote:

> > Therefore my memory must have been wrong -- I thought that you told me 
> > when I was merging f89bd95c5c that the devices are not standard HID 
> > devices at all, and therefore they can be safely ignored by the driver 
> > right away, as they can't be driven by HID driver anyway.
> These usb devices provide several different functions through the same
> interface. By default, it looks like a regular mouse interface, which
> HID will claim. This is why we need the quirks.

That I fully understand. But I though that the device is so much HID 
standard non-compliant, that even basic functionality is not possible with 
the generic HID driver, and therefore blacklisting it immediately can't do 
any harm. That's what I understood previously. But if this is wrong, and 
the HID code can get at least basic functionality from the device, I will 
revert the blacklist addition.

Thanks,

-- 
Jiri Kosina
SUSE Labs
