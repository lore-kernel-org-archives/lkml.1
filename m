Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYDFKUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYDFKUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 06:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYDFKUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 06:20:33 -0400
Received: from smtp25.orange.fr ([193.252.22.23]:39669 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbYDFKUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 06:20:32 -0400
X-ME-UUID: 20080406102027397.611F91C00095@mwinf2556.orange.fr
Subject: power off USB port
From: Xavier Bestel <xavier.bestel@free.fr>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 06 Apr 2008 12:20:24 +0200
Message-Id: <1207477224.3785.10.camel@bip.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to power off some usb ports (to make ejected usb flash drives
power off their little "don't remove me yet" led), but I can't find how
to do it with a 2.6.24 kernel:
- eject /dev/sd? doesn't work anymore
- /sys/bus/usb/devices/*/power/state doesn't exist anymore
- hub-ctrl-2.c [1] fails with a "Broken pipe" error

Does anyone know how to achieve that ?

Thanks,
	Xav


[1]: http://www.gniibe.org/log/linux


