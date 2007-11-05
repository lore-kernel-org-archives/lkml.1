Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbXKEBLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbXKEBLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 20:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXKEBLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 20:11:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:45904 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbXKEBLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 20:11:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AdnNX6FQ6bb2Eu5gFjVsXrmZMHIK6QEQy1tsJQfeZnY+CXXJLltaOK8TvP3/FjrchWB5VGZFE/ZAZz5aP1AKpFLJP53jywPi5ZKuhVToS0FufL3Uw5MsFkpGzq3elhjQ4ZLpFqsZAON4rGU8OR6CYWPb9Lc1qcWa64IHz8p+Dho=
Message-ID: <f17812d70711041711x215e6fbdtd14ba74bff5e7aec@mail.gmail.com>
Date: Mon, 5 Nov 2007 09:11:21 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: linux-main <linux-kernel@vger.kernel.org>
Subject: duplicate device name print out by dev_xxxx
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I found in recent kernel that dev_xxxx() macros will print out duplicate
device name, which is a bit ugly. And this is true at least for platform_device.

The reason is due to dev_printk() printing out both dev_driver_string(dev)
and (dev)->bus_id, the latter is assigned with the same driver name
for a platform_device.

Any idea on this?

-- 
Cheers
- eric
