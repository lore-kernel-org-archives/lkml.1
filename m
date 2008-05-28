Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYE1QXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYE1QXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYE1QX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:23:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:45716 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYE1QX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZPxJS751KtPov3McZI5O34lkAs4U/k/PhkxVkwDcI4voFQhm+5KNAMkX8EdOZ+DarMDpJ925+N1CHYCOnfV1RmBM/AMQpMqp9TVko2RYEwde6uAhz5dh14j2OQStwcDoK9oDc8e9ne7xpi6K/AceARkPe/el+fdt7dVIIEUitKw=
Message-ID: <6844644e0805280923q6ae8fdd6pcf92f726f420afe4@mail.gmail.com>
Date: Wed, 28 May 2008 12:23:25 -0400
From: "Doug Reiland" <dreiland@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Kbuild changes since 2.6.21??
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some makefiles that look at CONFIG_XXXX variables to make
decisions. For example, drivers/power/Makefile has the following
lines:

ifeq ($(CONFIG_SYSFS),y)
power_supply-objs += power_supply_sysfs.o
endif


If I run make clean or make mrproper, it doesn't see CONFIG_SYSFS set
anymore so it doesn't cleanup power_supply_sysfs.o.

This is for 2.6.25, but I think this use to work for 2.6.21. I am
using drivers/power/Makefile as an example, but I am seeing the same
thing for my driver's Makefile.

Thanks in advance.
