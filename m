Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0CKInX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:43:23 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:65230 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab0CKInV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:43:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length
         :organization:to:content-type:content-transfer-encoding:message-id;
        b=HvVp5hCxRPKi0XpB+/vOrEfd9Eq+xyYN17ElKnw9sXRuJL99rINEfz/Y8s2tKmyXL2
         Ieqzncftw5V7FBx3Kywi+GJjlH10a0u1UuvQDxjtBsSbSaTLAoxlLE0cHhtCIrDtdUoA
         siWpmwqBXdxPcC07Psk+UjL/XNUFVoPOPpTFY=
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 11 Mar 2010 09:42:03 +0100
Subject: [PATCH v2 0/4] RDC321x southbridge and GPIO support
MIME-Version: 1.0
X-TUID: 7451549afc5926f1
X-Length: 1392
Organization: OpenWrt
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
       Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003110942.03602.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim, Samuel, Ingo,

Here are 4 patches relative to adding support for the RDC321x southbridge.
This southbridge is present on all x86-based RDC321x System-on-a-Chip and
provides access to GPIOs and Wathchdog. The watchdog driver is already merged.

Samuel, this is rebased on top of your mfd-2.6 master branch after commit 
522dba7 and I think the 4 patches should go via your tree to make sure the 
merge is consistent.

Thank you.

Florian Fainelli (4):
  x86: remove rdc321x_defs.h
  MFD: add support for the RDC321x southbridge
  GPIO: add support for RDC321x GPIO controller
  WATCHDOG: convert rdc321x_wdt to use southbridge accessors

