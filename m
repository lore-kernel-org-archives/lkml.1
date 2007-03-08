Return-Path: <linux-kernel-owner+w=401wt.eu-S1751741AbXCHEig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbXCHEig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 23:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbXCHEig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 23:38:36 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:33390 "EHLO
	asav05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbXCHEig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 23:38:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KADIi70VKhRO4UGdsb2JhbACHTYdZAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input fixes for 2.6.21-rc3
Date: Wed, 7 Mar 2007 23:38:36 -0500
User-Agent: KMail/1.9.3
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703072338.37771.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from:

        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive fix for AUX IRQ delivery test that causes missing keyboards
on some boxes without PS/2 mice. The fix is confirmed to be working for
MSI K8M800 and also confirmed not to break previous fix (re. bugzilla
7833).

Changelog:
----------
Dmitry Torokhov (1):
      Input: i8042 - another attempt to fix AUX delivery checks

Diffstat:
---------
 i8042.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

-- 
Dmitry
