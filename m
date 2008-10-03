Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYJCOgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYJCOgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYJCOgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:36:36 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:58595 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYJCOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:36:35 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Date: Fri,  3 Oct 2008 16:36:28 +0200
Message-Id: <1223044589-31741-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Support for Silicon C2 Interface.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C2 port implements a two wire serial communication protocol (bit
banging) designed to enable in-system programming, debugging, and
boundary-scan testing on low pin-count Silicon Labs devices.

Main references are at Silicon Laboratories site:

* AN127: FLASH Programming via the C2 Interface
     http://www.silabs.com/public/documents/tpub_doc/anote/Microcontrollers/Small_Form_Factor/en/an127.pdf

* C2 Specification
     http://www.silabs.com/public/documents/tpub_doc/spec/Microcontrollers/en/C2spec.pdf

Currently this code supports only flash programming through sysfs
interface but extensions shoud be easy to add.

I know that this (proposal) patch may be incomplete but I'd like to
know what you are thinking about it before continuing further. For example
I'd like to know if should I put the C2 port core here or into proper
subdirectory of linux/drivers/misc/ where clients can be placed also.

Thanks for your suggestions,

Rodolfo

--

 drivers/misc/Kconfig       |   13
 drivers/misc/Makefile      |    1
 drivers/misc/c2port_core.c |  996 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/c2port.h     |   65 ++
 4 files changed, 1075 insertions(+)


