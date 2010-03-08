Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0CHMNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 07:13:36 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:38863 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab0CHMNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 07:13:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length
         :organization:to:cc:content-type:content-transfer-encoding
         :message-id;
        b=eGHw79i77bU3rlgo36TsFZ+QyRs4Aez9xEgNjlzoaJDwPLjwItrM7bX5Sz5Kdq0wb4
         zTkFofrdSZMbnRqN9A38x0slMWdgRUu9KJHA6ibU+4bhxupmNGS5CzIDP1M+1QGUBVbD
         XByobHOneoZL2sKky9/YkpckrLgCkiKURzTPE=
From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 8 Mar 2010 13:12:34 +0100
Subject: [PATCH 0/4] RDC321x southbridge and GPIO support
MIME-Version: 1.0
X-TUID: db196cf98d0e41e1
X-Length: 1389
Organization: OpenWrt
To: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
       Ingo Molnar <mingo@elte.hu>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003081312.34538.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel, Wim,

Here are 4 patches relative to adding support for the RDC321x southbridge.
This southbridge is present on all x86-based RDC321x System-on-a-Chip and
provides access to GPIOs and Wathchdog. The watchdog driver is already merged.

Regards, Florian Fainelli (4):
  x86: remove rdc321x_defs.h
  MFD: add support for the RDC321x southbridge
  GPIO: add support for RDC321x GPIO controller
  WATCHDOG: convert rdc321x_wdt to use southbridge accessors
