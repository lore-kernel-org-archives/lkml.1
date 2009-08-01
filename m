Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZHAHyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZHAHyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZHAHys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:54:48 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51307 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbZHAHyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:54:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=unUVWZz44mlIh8TOtQpftU24p+oCxWxy+2hQi1I9BFHtAIUSv6DniTa2LcACnDI+bG
         yDmDRyrp9AOxJjeiOd3BjY3eJ1zTHzYnV4dfrmU4TiQnJojh0J44QKyVgFUrEoluKB+6
         g41TU7TqgAHbTYhvU88W1R+tpXgh6PnrV+x1g=
Message-Id: <20090801074758.502095557@openvz.org>
User-Agent: quilt/0.47-1
Date: Sat, 01 Aug 2009 11:47:58 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: yinghai@kernel.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 0/2] x86,ioapic simplification,bugfix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the series has an idea to simplify io-apic list
handling and prevent from one possible NULL
dereference. See patches comments for details.

Yinghai, please take a closer look on new body
of add_pin_to_irq_node and __eoi_ioapic_irq.

I hope I didn't miss anything.

Please review. Comments are highly appreciated.

The patches on top of -tip tree commit

	| commit 160bc9d163b0ba927770056783b79a684b74acc6
	| Merge: d333597 d6c585a
	| Author: Ingo Molnar <mingo@elte.hu>
	| Date:   Sun Jul 26 14:32:39 2009 +0200
	|
	|    Merge branch 'x86/urgent'

Cyrill
