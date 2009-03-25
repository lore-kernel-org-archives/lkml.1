Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZCYXHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZCYXHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZCYXHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:07:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:33492 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZCYXHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:07:31 -0400
Date: Thu, 26 Mar 2009 00:07:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: linux-kernel@vger.kernel.org
Subject: What's in hid.git for 2.6.30
Message-ID: <alpine.LNX.2.00.0903251742520.14346@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

below is the list of changes queued in HID tree for 2.6.30. 

Apart from the usual stuff (support for new devices, small fixes), the 
most notable change is USB autosuspend support for the usbhid driver 
written by Oliver Neukum.

Also the compat stuff for legacy hotplug is scheduled for removal.

Anssi Hannula (1):
      HID: add support for another version of 0e8f:0003 device in hid-pl

Jiri Kosina (5):
      HID: bring back possibility to specify vid/pid ignore on module load
      HID: do not try to compile PM code with CONFIG_PM unset
      HID: hid_reset_resume() needs to be defined only when CONFIG_PM is set
      HID: support for Kensington slimblade device
      HID: add support for Kye/Genius Ergo 525V

Jiri Slaby (1):
      HID: remove compat stuff

Oliver Neukum (4):
      HID: autosuspend support for USB HID
      HID: fix race between usb_register_dev() and hiddev_open()
      HID: fix USB HID devices after STD with autosuspend
      HID: autosuspend -- fix lockup of hid on reset

Paul Collins (1):
      HID: constify arrays of struct apple_key_translation

Pavel Machek (1):
      HID: make HID_DEBUG defaults consistent

Richard Walmsley (1):
      HID: DragonRise game controller force feedback driver

Ryan Finnie (1):
      HID: Support Apple mini aluminum keyboard

-- 
Jiri Kosina
SUSE Labs
