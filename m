Return-Path: <linux-kernel-owner+w=401wt.eu-S1762791AbXG3Mpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762791AbXG3Mpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 08:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbXG3Mpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 08:45:33 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34639 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbXG3Mpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 08:45:32 -0400
Date: Mon, 30 Jul 2007 14:45:19 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Christian Lamparter <chunkeey@web.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] usbhid: add ASUS LCM to the blacklist
In-Reply-To: <200707270110.01135.chunkeey@web.de>
Message-ID: <Pine.LNX.4.64.0707301440020.5747@twin.jikos.cz>
References: <200707240228.39421.chunkeey@web.de> <20070726152709.6daa1c96.akpm@linux-foundation.org>
 <200707270110.01135.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007, Christian Lamparter wrote:

> Some of ASUS' notebooks (e.g G Series) include a tiny oled display, which is 
> attached to an internal USB bus. Unfortunatly the device reports a wrong
> DeviceDescriptor and is therefore identified as a HID device...

Hi Christian,

I have slightly modified your patch (let's keep the hid_blacklist[] 
properly sorted) and applied it into my tree.

Thanks,

-- 
Jiri Kosina
