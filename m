Return-Path: <linux-kernel-owner+w=401wt.eu-S932644AbXIFWXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbXIFWXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbXIFWX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:23:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132AbXIFWX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:23:27 -0400
Message-ID: <46E07DDA.2040907@redhat.com>
Date: Thu, 06 Sep 2007 18:23:22 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: David Brownell <david-b@pacbell.net>
Subject: Two identical entries for "rtc" in /proc/devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# ls -li
total 0
4026532007 -r--r--r-- 1 root root 0 Sep  6 18:18 nvram
4026532067 -r--r--r-- 1 root root 0 Sep  6 18:18 rtc
4026532067 -r--r--r-- 1 root root 0 Sep  6 18:18 rtc
4026532056 -rw-r--r-- 1 root root 0 Sep  6 18:18 snd-page-alloc

kernel 2.6.22.6 on a Dell Precision 390:

# CONFIG_RTC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_GEN_RTC=y
CONFIG_GEN_RTC_X=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS1742=m
# CONFIG_RTC_DRV_EP93XX is not set
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_SA1100 is not set
# CONFIG_RTC_DRV_TEST is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_V3020=m

CONFIG_HPET_EMULATE_RTC=y

CONFIG_EFI_RTC=y
