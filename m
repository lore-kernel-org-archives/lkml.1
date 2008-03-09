Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYCIQsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYCIQsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 12:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYCIQsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 12:48:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:31238 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbYCIQsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 12:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cKOcI8DIf09n2+YkpJSlPky9iqp5755U9U7DisL7tafjULeSqt9y1WBHwbzFN3YANvaN5SIt/2Txeq58YNR1IcIEI8lgGWsfKH6fm6RtcjTMOi69uKbgaBN8hsiKIW9eYM1ZO4ASeoa8A2eG6iMoGbMGUZFZ0QJjhHcWEmGCI3g=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 0/3] v4l: reduce stack usage
Date: Sun,  9 Mar 2008 17:47:43 +0100
Message-Id: <1205081266-18368-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
This little patchset reduces stack usage of v4l_compat_translate_ioctl.

[PATCH 1/3] v4l: fix coding style violations in v4l1-compat.c
[PATCH 2/3] v4l: reduce stack usage of v4l_compat_translate_ioctl
[PATCH 3/3] v4l: reduce stack usage of v4l1_compat_sync

(compile tested only)

Marcin Slusarz

 drivers/media/video/v4l1-compat.c | 1839 ++++++++++++++++++++------------------
 1 file changed, 1016 insertions(+), 823 deletions(-)
