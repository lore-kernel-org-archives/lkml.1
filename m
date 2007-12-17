Return-Path: <linux-kernel-owner+w=401wt.eu-S1763476AbXLQNnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763476AbXLQNnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760523AbXLQNnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:43:19 -0500
Received: from twin.jikos.cz ([213.151.79.26]:36184 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760200AbXLQNnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:43:18 -0500
Date: Mon, 17 Dec 2007 14:43:07 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1 compile failure: usbhid_lookup_quirk
In-Reply-To: <20071217025238.252f3e89.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712171442180.29278@twin.jikos.cz>
References: <20071215185040.GA32609@amd64.of.nowhere>
 <20071217025238.252f3e89.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007, Andrew Morton wrote:

> >   MODPOST 196 modules
> >   ERROR: "usbhid_lookup_quirk" [drivers/hid/usbhid/usbmouse.ko]
> >   undefined!
> >   ERROR: "usbhid_lookup_quirk" [drivers/hid/usbhid/usbkbd.ko] undefined!
> >   make[1]: *** [__modpost] Error 1
> >   make: *** [modules] Error 2
> > The problem was fixed by defining CONFIG_USB_HID=m - but I think that
> > should happen automatically if it is necessary.
> > .config was created by running make oldconfig against 2.6.23-rc8-mm2:
> Thanks.  That's coming out of git-hid.patch.

Thanks a lot for the report, I will fix that up in my tree.

By the way, please be aware that you almost certainly _do not_ want to use 
usbmouse and usbkbd drivers. Please read their Kconfig help text.

-- 
Jiri Kosina
