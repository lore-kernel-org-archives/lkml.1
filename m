Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZIIK7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZIIK7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 06:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZIIK7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 06:59:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:46141 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZIIK7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 06:59:08 -0400
Date: Wed, 9 Sep 2009 12:59:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: linux-kernel@vger.kernel.org
Subject: What's in hid.git for 2.6.32
Message-ID: <alpine.LNX.2.00.0909091146430.23856@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

below is a summary of what is queued in HID tree for the upcoming merge 
window. Apart from new support for quite some quirky hardware and simple 
code fixes, I have rewritten the debugging stub (which is used very often 
to diagnose problems with faulty devices) to use debugfs, to make life 
easier both for developers and users reporting problems with their 
devices.

Bruno Premont (1):
      HID: driver for Twinhan USB 6253:0100 remote control

H Hartley Sweeten (1):
      HID: local function should be static

Henning Glawe (1):
      HID: ignore Philips IEEE802.15.4 RF Dongle

Jan Scholz (1):
      HID: completely remove apple mightymouse from blacklist

Jarod Wilson (1):
      HID: ignore all recent SoundGraph iMON devices

Jiri Kosina (6):
      HID: use debugfs for report dumping descriptor
      HID: use debugfs for events/reports dumping
      HID: fix debugfs build with !CONFIG_DEBUG_FS
      HID: fix memory leak on error path in debug code
      HID: add force feedback support for Logitech WingMan Formula Force GP
      HID: support larger reports than 64 bytes in hiddev

Julia Lawall (2):
      HID: Drop NULL test on list_entry result
      HID: fix memory leak on error patch in debug code

Peter Huewe (1):
      HID: adding __init/__exit macros to module init/exit functions

Rafi Rubin (1):
      HID: ntrig tool separation and pen usages

Robert Schedel (1):
      HID: Support new variants of Samsung USB IR receiver (0419:0001)

Roel Kluin (1):
      HID: fix overrun in quirks initialization

Ruben Aos Garralda (1):
      HID: add rumble support for Thrustmaster Dual Trigger 3-in-1

Sergey Senozhatsky (1):
      HID: Avoid double spin_lock_init on usbhid->lock

