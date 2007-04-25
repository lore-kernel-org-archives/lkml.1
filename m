Return-Path: <linux-kernel-owner+w=401wt.eu-S1423329AbXDYJCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423329AbXDYJCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423330AbXDYJCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:02:31 -0400
Received: from smtp-2.orange.nl ([193.252.22.242]:53374 "EHLO smtp-2.orange.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423329AbXDYJCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:02:30 -0400
X-ME-UUID: 20070425090228535.82BB71C00088@mwinf6104.orange.nl
From: Gerrit Binnenmars <gerritbinnenmars@wanadoo.nl>
Reply-To: gerritbinnenmars@wanadoo.nl
To: linux-kernel@vger.kernel.org
Message-ID: <1332927.417261177491748521.JavaMail.www@wwinf6102>
Subject: 2.6.20-rt8 BUG at startup
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [77.161.242.98]
X-Wum-Nature: EMAIL-NATURE
X-WUM-FROM: |~|
X-WUM-TO: |~|
X-WUM-REPLYTO: |~|
Date: Wed, 25 Apr 2007 11:02:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On an ARM XSCALE running on a gumstix platform I get the following BUG report at startup
after applying the -rt8 patches. 

BUG: at kernel/sched.c:4031 __schedule()
[<c001cfd8>] (dump_stack+0x0/0x24) from [<c014c214>] (__schedule+0x714/0x764)
[<c014bb00>] (__schedule+0x0/0x764) from [<c014c44c>] (schedule+0xcc/0x114)
[<c014c380>] (schedule+0x0/0x114) from [<c0043f8c>] (kthread+0xc8/0x128)
 r4 = 00000000
[<c0043ec4>] (kthread+0x0/0x128) from [<c0031548>] (do_exit+0x0/in860)
 r7 = 00000000  r6 = 00000000  r5 = 00000000  r4 = 00000000
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

This is the warning that is displayed only once to indicate that the irqs are not disabled?
How can this be solved? On the gumstix mailing list this is reported several times without any response.

Please CC me personally.

Greetings Gerrit


