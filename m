Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab0CLMLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 07:11:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:16495 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab0CLMK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 07:10:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ZHACqN3UFUkEfF2T6AcvcLImxFD9RAJ3k1R950WNZTiUH7+WmGAAUM0/AGX5l4Wc18
         6ZGXvxl+Ea+hG00P+tEfKzVgRZWBgBFVc0u0hWvZYvQ6V4Ktop8AptWZsZkaDwJbU+Gn
         Wh8gxXS6nz2woqU0mxwsCScZ/Wnm5sDZjpKqw=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH] Build break in v2.6.33-rt6
Date: Fri, 12 Mar 2010 13:10:49 +0100
Message-Id: <1268395850-23408-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following fixes a build break in v2.6.33-rt6 due to the merging of
git://dev.lemote.com/rt4ls into rt 1054085e15d189e05d4d6ea7e30580c4e0b36d7f

John Kacur (1):
  ide: Build break in ide-iops.c

 drivers/ide/ide-iops.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

