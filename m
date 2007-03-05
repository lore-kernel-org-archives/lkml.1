Return-Path: <linux-kernel-owner+w=401wt.eu-S933664AbXCEVzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbXCEVzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933669AbXCEVzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:55:11 -0500
Received: from twin.jikos.cz ([213.151.79.26]:40933 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933667AbXCEVzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:55:10 -0500
Date: Mon, 5 Mar 2007 22:54:46 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Amedee Van Gasse <amedee@amedee.be>
cc: LKML <linux-kernel@vger.kernel.org>, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
In-Reply-To: <1173122352.19761.33.camel@saruman>
Message-ID: <Pine.LNX.4.64.0703052249270.10909@twin.jikos.cz>
References: <1173122352.19761.33.camel@saruman>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(added Marcel to CC)

On Mon, 5 Mar 2007, Amedee Van Gasse wrote:

> It _appears_ that the bug reports started after an update of 
> bluez-utils, but this remains to be confirmed. It could be 
> coincidence/temporal correlation (which does not imply causation).

This would be in fact very interesting to know. 1) does the BUG trigger 
only with newer versions of bluez-utils? 2) If so, does everything work 
with these older versions, or do the things fail in a same way, but 
silently?

> Anyway, is this a kernel problem or is bluez-utils to blame?

I would bet that the problem is that we don't know yet the correct 
vendor-specific report that is needed to be sent to the dongle to switch 
from HID to HCI mode. 

> PS: I bumped into this topic when googling for "046d:c70e". I'm not a 
> developer (I'm what they call "a user"), but I'm not afraid to get my 
> hands dirty. If you want me to run debug versions or patched kernels, I 
> can do that. After all, I have the hardware and I might give you 
> valuable information (even if I wouldn't recognise it when it spat me in 
> the face).

Would you also be capable of catching the report which switches the dongle 
from HID to HCI in other operating system, for which there already is a 
support?

Thanks,

-- 
Jiri Kosina
