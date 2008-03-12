Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbYCLTdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbYCLTdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYCLTdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:33:35 -0400
Received: from eazy.amigager.de ([213.239.192.238]:54973 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYCLTdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:33:33 -0400
Date: Wed, 12 Mar 2008 20:34:05 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: broken access to a USB HID device after suspend
Message-ID: <20080312193405.GA23209@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I use a tool called hidmon to control the parameters of my LCD in shell
scripts. I just had the case where this tool didn't work after suspend
to RAM. I just got this error message:

hid_force_open failed with return code 13

The kernel log contains lines like this:

usb 1-1.3: usbfs: USBDEVFS_CONTROL failed cmd hidmon rqt 129 rq 6 len 9 ret -110

Unplugging and replugging the USB cable of the LCD didn't work.
However, after a further suspend/resume cycle it works.

This is Linux 2.6.25-rc5. The behaviour is not repoducible, though.
However, I just mention it for the case that this might ring a bell
somewhere.

Regards,
Tino
