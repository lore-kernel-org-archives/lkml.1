Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbZKMGd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbZKMGd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 01:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZKMGdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 01:33:20 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:50092 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbZKMGdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 01:33:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CcYDxY37J0v9GIFWC2UOszULRpOi3ym/lBXwPvLOalF4tZ3oFRCJmQ3Bxk3/4dKJj6
         QQ/dbHleX3Sbi4tg5w71xHBkOonrJ6d1e+Ohq2+bmSbS4jXlnAQV8nFordIV4JDK7Orv
         dSs6e0YYUazVBnlKlZdSh/ir8wmtsmbQrr8xg=
MIME-Version: 1.0
Date: Thu, 12 Nov 2009 22:33:25 -0800
Message-ID: <6f5aac130911122233r57936a8ek920208622019737a@mail.gmail.com>
Subject: i2c_detect Vs i2c_probe
From: saurabh chokshi <sdchokshi@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ,

I am emailing with reference to the thread on linux kernel.

http://lkml.indiana.edu/hypermail/linux/kernel/0304.0/0495.html

I am currently writing i2c driver for Power Supply. I also have the same query.

Whenever I insert the module, and if the i2c_detect detects the device
with address mentioned in normal_i2c array, then mydriver_detect gets
called.

However, I was just wondering that when i2c_probe gets called. You can
explicitly call i2c_probe and pass i2c_attach function pointer. Could
you please share your knowledge with me?


Best Regards,
---------------------------------------
Saurabh D Chokshi
Master of Science - Computer Science
University of Southern California,
Los Angeles, CA
