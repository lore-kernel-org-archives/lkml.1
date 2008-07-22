Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYGVNJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYGVNJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYGVNIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:08:54 -0400
Received: from styx.suse.cz ([82.119.242.94]:33585 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751023AbYGVNIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:08:53 -0400
Date: Tue, 22 Jul 2008 15:08:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, robfitz@273k.net,
       akpm@osdl.org, Vojtech Pavlik <vojtech@suse.cz>, dmonakhov@openvz.org
Subject: Re: [PATCH] hid: wellspring device quirks
In-Reply-To: <1215963466.12757.0.camel@alnilam>
Message-ID: <alpine.LNX.1.10.0807221504380.3037@jikos.suse.cz>
References: <1215963466.12757.0.camel@alnilam>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008, Henrik Rydberg wrote:

> This patch adds the HID_QUIRK_IGNORE_MOUSE quirk for the Apple USB
> multitouch devices based on BCM5974, aka Wellspring. These devices
> will instead be picked up by the new bcm5974 driver.

Hi Henrik,

is the mouse not working at all with standard HID driver?

I'd prefer to postpone merging this patch until bcm5974 hits mainline if 
the device works in a limited way with standard HID driver, so that we 
don't introduce regression.

If the device doesn't work with HID driver at all though, it is probably 
perfectly fine to merge it right away. Please let me know, I have no 
knowledge about this particular device.

Thanks a lot,

-- 
Jiri Kosina
SUSE Labs
