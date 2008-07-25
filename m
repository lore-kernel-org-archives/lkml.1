Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYGYS0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYGYS0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYGYSZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:25:58 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:38417 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755397AbYGYSZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:25:56 -0400
Message-ID: <488A1A99.2070609@euromail.se>
Date: Fri, 25 Jul 2008 20:25:29 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net
Subject: Re: [PATCH] bcm5974-0.58: name changes, open/close and	suspend/resume
 serialized
References: <4888311E.9010005@euromail.se> <20080725154250.GA1861@anvil.corenet.prv>
In-Reply-To: <20080725154250.GA1861@anvil.corenet.prv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.11
X-Scan-Result: No virus found in message 1KMRzF-0002Oc-5Y.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KMRzF-0002Oc-5Y 6f01e3f0db051c12054ac1df6db64f24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,
> 
> Thank you for the changes.  You don't have to track whether device is
> manually suspended or not - usb_submit_urb will fail and that is it.
> 

Perfect.

> Attached are 2 patches. First cleans suspend state tracking as it is not
> really needed and does some formatting and other minor changes and 2nd
> implements runtime pm for the device. Could you please try them and if
> everything still works I will apply the driver.

Patch 1:

  Looking good, just a few comments:

  * I notice that clamp_val is new since 2.6.24.3
  * Regarding the open-fails comment: is EACCES correct?

Patch 2:

  Perfect.

Thank you so much, Dmitry - it's a GO!

Henrik

