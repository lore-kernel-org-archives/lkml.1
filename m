Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbYKSXKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYKSXKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYKSXKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:10:08 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:51997 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbYKSXKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:10:06 -0500
Message-ID: <49249CCB.7060807@euromail.se>
Date: Thu, 20 Nov 2008 00:10:03 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Complete support for the new unibody macbooks
References: <49109C91.6090207@euromail.se> <alpine.LNX.1.10.0811111835540.24889@jikos.suse.cz> <4919C979.3000501@euromail.se> <alpine.LNX.1.10.0811112347260.24889@jikos.suse.cz> <20081119113753.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.10.0811191803320.19853@jikos.suse.cz> <49249431.9040104@euromail.se> <alpine.LNX.1.10.0811192339560.19853@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0811192339560.19853@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1L2wBQ-0008Fp-6b.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1L2wBQ-0008Fp-6b 793f8d6cfac298af21edf88e075e1124
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 19 Nov 2008, Henrik Rydberg wrote:
> 
>> Without the mouse ignore quirk, HID will find the "normal" usb mouse 
>> interface. The current situation is much worse than to throw the bcm5974 
>> patches in untested. And this is not even the case; the updated driver 
>> has been in use as a dkms package for almost a month.
> 
> Therefore my memory must have been wrong -- I thought that you told me 
> when I was merging f89bd95c5c that the devices are not standard HID 
> devices at all, and therefore they can be safely ignored by the driver 
> right away, as they can't be driven by HID driver anyway.

These usb devices provide several different functions through the same
interface. By default, it looks like a regular mouse interface, which
HID will claim. This is why we need the quirks.

> If this is not the case, I'll then revert the hid_mouse_ignore_list[] 
> addition peformed in a96d6ef34 and will push it for 2.6.29, so that it 
> goes in together with bcm5974 driver modifications.

Yes, I think that is best.

> Thanks and sorry if I messed this up,

No harm done. :-)

Thanks,
Henrik

