Return-Path: <linux-kernel-owner+w=401wt.eu-S1030691AbXCCRbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030691AbXCCRbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 12:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030693AbXCCRbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 12:31:55 -0500
Received: from colgate.yandex.ru ([213.180.200.34]:46841 "EHLO
	colgate.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030691AbXCCRby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 12:31:54 -0500
Date: Sat, 3 Mar 2007 20:31:37 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45E9B0F9.000001.20831@colgate.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: Question: work_queue or kthreads
X-MsgDayCount: 5
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.232.70
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I need to use something like the work_queue to separate my ISR and long time sending data function in my driver. I noticed, that after using work_queue my driver became slow than it was before. Should I use kthreads to make it faster or something else? I can't use tasklet since tasklet can't sleep.

thank you
