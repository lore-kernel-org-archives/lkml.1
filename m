Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbXHPWwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbXHPWwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXHPWwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:52:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:2691 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbXHPWwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gvwtJJmTk6CPLr3u1l1ZZXh9sUnj0joCJ88JdX/X6WQvNYjcEhZnl5r/Bk5hHrnijuaxj7uDVEdIPmx5sD4Wd128tbgh98iYLlsgK2X9EMqfMrImSDjF86O1IZadbJhEslWvLIT2KCleBAIGRn//e5/gJ57DWlPp2z7lg/FoooE=
Message-ID: <f40fb4250708161552ub87bf8ve8168eec1b3955e7@mail.gmail.com>
Date: Fri, 17 Aug 2007 02:52:03 +0400
From: GolovaSteek <golovasteek@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: nanosleep() accuracy
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
I need use sleep with accurat timing.
I use 2.6.21 with rt-prempt patch.
with enabled rt_preempt, dyn_ticks, and local_apic
But

req.tv_nsec = 300000;
req.tv_sec = 0;
nanosleep(&req,NULL)

make pause around 310-330 microseconds.

I tried to understend how work nanosleep(), but it not depends from
jiffies and from smp_apic_timer_interrupt.

When can accuracy be lost?
And how are process waked up?


GolovaSteek
