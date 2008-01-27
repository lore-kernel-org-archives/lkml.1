Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYA0CyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYA0CyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYA0Cxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:53:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:37169 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYA0Cxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:53:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=RV9LPxLEsngZC7rf0U079SVAzd9JYDG8rUSMCK8VmHkOXvp7gBVIQGtY22sh23tNJy6UnuOs88XZrb9HmhTbN1DVeLBQMFdQL5svDsW+PWj8XoMBJlznA1Mh36LaUof2CVUer2e3z89unRfKmcedwATFqccI3QrfV8q7sVGMyO4=
Message-ID: <479BF21B.8070104@googlemail.com>
Date: Sun, 27 Jan 2008 03:53:15 +0100
From: =?ISO-8859-15?Q?Michael_K=FChn?= <breiteseite1337@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071214)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org
Subject: [PATCH 1/1] 2.6.24, net/bluetooth/hci_sysfs.c, cleaned code remove
 compiler warning
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the attached Patch will remove a compiler warning in
net/bluetooth/hci_sysfs.c:

--- hci_sysfs.c 2008-01-27 03:48:47.000000000 +0100
+++ hci_sysfs.c_new     2008-01-27 03:37:19.000000000 +0100
@@ -332,7 +332,7 @@
        struct device *dev;
        struct hci_conn *conn = container_of(work, struct hci_conn, work);

-       while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
+       while ((dev = device_find_child(&conn->dev, NULL, __match_tty))) {
                device_move(dev, NULL);
                put_device(dev);
        }
