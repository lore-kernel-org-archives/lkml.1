Return-Path: <linux-kernel-owner+w=401wt.eu-S1765412AbXGNBkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765412AbXGNBkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764275AbXGNBkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:40:06 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:54689 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763715AbXGNBkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WFYa66Yt1vnVgHNB0M4pZuQ7/sRAJ70TeBZfTE47iMmUt3+kjhdgtnF3BeLxDlSryLb+94f5la3gZZCILBJvvOsGP4RQX0uC6I+xtZ7+awnJuYnAP/n0uHe6XgZOxRV+e9Jzqh97bkRvBftTbf1L2y1geAt5vMYJytFIgN9NJTY=
Message-ID: <20f65d530707131840x4ef825f1sa64ef8b66ec863c9@mail.gmail.com>
Date: Sat, 14 Jul 2007 13:40:02 +1200
From: "Keith Chew" <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: One Vendor/Device ID multiple instances of driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We have a WIFI driver that only supports a single device at a time. We
want to use 2 devices with the same vendor/device ID, but spawn 2
instances of the same driver. Each instance will handle a single
device.

If we bought the devices from 2 vendors, we'd have 2 DeviceIDs, we can
modify the driver to look at different IDs, which will solve our
problem. But how can we achieve this if we wanted to use the same
device from the same vendor?

Regards
Keith
