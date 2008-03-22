Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbYCVXXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbYCVXXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 19:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYCVXXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 19:23:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:40237 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbYCVXXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 19:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NJ3ILh63AwyP5o0dpq2it75q+6uauQheVzxje+T+jixdidsNfo4RBIDq3VmZCJK8eBRN7lCrLombCYp9brJyjkxv3DkouJF3dDK/syVpAHtmwjkictshu20KLa7SpFlgPuzBV53v4td5okW3CLDHYqf0MrHHA544XUp+4nTnjoQ=
Message-ID: <dd18b0c30803221623p16d6e47fjedd15a0ce34a576a@mail.gmail.com>
Date: Sat, 22 Mar 2008 23:23:34 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: rh_timer_func
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello;
I'm not going to talk about fglrx. My goal right now is to make sure
everything is up and running i.g. keyboard,isight,ati,infrared
receiver etc... So I can focus on tyring
to get the macbook to four hours of battery life. here is a list of
problems I see, Hopefully I can get some answers  so linux can reach
the spec on a mac, or even better:

drivers/hid/usbhid/hid-core.c: couldn't find an input interrupt endpoint.

this error occurs randomly every so often:
drivers/input/mouse/appletouch.c: could not do mode read request from
device (Geyser Raw mode)
appletouch: probe of 1-2:1.1

suspend was working at around 2.6.21, then never worked.

When using powertop I was able to reach around 3:10hrs at 16W, running
OSX I see around 4:17 on a fresh battery.
 I've noticed the processor goes to the C3 state, but stays at 100%
due to too many interrupts: a main interrupt I see is this one =
<kernel modules> : usb_hcd_poll_rh_status (rh_timer_func); when the
system is powered on this timer is around 1.1% then when powering down
the system; i.g. turning of daemons, and rrmod, this timer goes to
around 80-90%. I've read the usb documentation; but seem to be missing
something to have this timer fall asleep.
any help would be appreciated.

-- 
Justin P. Mattock
