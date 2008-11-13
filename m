Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYKMBy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYKMBy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYKMByX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:54:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:37141 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYKMByT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:54:19 -0500
From: Kevin Hao <kexin.hao@windriver.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, Alan Cox <alan@redhat.com>, linux-usb@vger.kernel.org
Subject: [PATCH 0/2] fix two bugs in usb serial console
Date: Thu, 13 Nov 2008 09:53:35 +0800
Message-Id: <1226541217-32673-1-git-send-email-kexin.hao@windriver.com>
X-Mailer: git-send-email 1.6.0.3.640.g6331a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

1. we should init the kref of tty which used as a fake tty in usb
serial console setup function.

2. Fix can't open /dev/console bug when the console is a usb serial device.

With these two patches we can boot and login successfully on an Eee PC
with a pl2303 usb serial as console.

Thanks,
Kevin


