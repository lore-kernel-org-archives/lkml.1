Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXBVTRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXBVTRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXBVTRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:17:35 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:49627 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbXBVTRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:17:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ie9ViAqjQKOaRQepgRzgD7yi+RzkM3tysLHscshNwRltu0wLcJT/Asqa9zqbAjlZoWBu1UUPEPigUapuIp4auC3ELFfba6LQFRqoqzTjVAYj6hjunKBy3kLAMiWVLzjwqaIlB76wEzPuKF5DSinaAg7uUjjwb4JI6IBkm9buOcE=
Message-ID: <671c20540702221117p3f5c16b3h52173c94d17f7eda@mail.gmail.com>
Date: Thu, 22 Feb 2007 14:17:33 -0500
From: "Tom Burns" <tom.i.burns@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [r8169] Any success with RTL8110SC?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

  Does anyone have the Realtek gigabit RTL8110SC working?  From
reading the list it appears that support has been added to the r8169
in-kernel module.  I can't get it to work - unfortunately I'm forced
to use kernel 2.6.15-1 from Fedora Core 5 at the moment but I've
tried:

-backporting 2.6.18 to 2.6.20.1 versions of the module to work on
2.6.15-1 - it was trivial changes aside from 2.6.20.1 which required
changes to the task scheduling code, but I'm pretty certain I didn't
break anything.

-applying the patch originally provided in
http://www.uwsg.iu.edu/hypermail/linux/kernel/0702.0/0422.html to the
2.6.15-1 driver, or the 2.6.19.2 driver.

-using the r1000 v1.05 driver available from the realtek website.

The backported kernel modules successfully identify the rtl8110sc
device and provide the eth interface, but do not successfully
send/receive any packets on the wire.

The r1000 driver seems to be able to send data on the wire for about a
minute, receive packets back about 5% of the time, and after a minute
stop working altogether, complaining that the "send buffer is full."

Does anyone have this chipset working?

Cheers,
Tom Burns
