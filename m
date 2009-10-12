Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbZJLFhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbZJLFhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZJLFhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZJLFhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:37:37 -0400
From: Amit Shah <amit.shah@redhat.com>
To: rusty@rustcorp.com.au
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v8 0/1] virtio_console: Add support for multiple console ports and generic serial ports
Date: Mon, 12 Oct 2009 11:06:30 +0530
Message-Id: <1255325791-9086-1-git-send-email-amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Here is a new iteration of the patch series that implements a
transport for guest and host communications.

I've tested for compatibility (old qemu & new kernel, new qemu & old
kernel, new qemu & new kernel) and it all works fine. To maintain
backward compatibility, the first port to be spawned (port at id 0) is
to be a console port, to be bound to hvc. This keeps new host, old
guest happy.

Christian has tested the console functionality on s390.

Please review and apply,
	Amit

Amit Shah (1):
  virtio_console: Add support for multiple ports for generic guest and
    host communication

 drivers/char/Kconfig           |    6 +
 drivers/char/virtio_console.c  | 1290 +++++++++++++++++++++++++++++++++++-----
 include/linux/virtio_console.h |   50 ++-
 3 files changed, 1210 insertions(+), 136 deletions(-)

