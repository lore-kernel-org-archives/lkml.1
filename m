Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbYLIW2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbYLIW2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbYLIW2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:28:34 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:41798 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbYLIW2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:28:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=Ny+mr0yUtLQUbid3Na0joRqBM0nydamKo4LI9yhWFVs9s3M7nBE7EgxhcTBHvXYPVt
         10ym4567Q40yOroOIkUmkW84+fKeSbcsX9lYSZZnlUm7/kRcdYs6nmmBOsqCWVI94nLy
         jLR20G+sThVf3DYO+fMxmN7CZNJ7TjBcw+mLQ=
Message-ID: <493EF10F.6060203@gmail.com>
Date: Tue, 09 Dec 2008 23:28:31 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: avi@redhat.com, kvm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 31/31] virt: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a87f45e..6bf6d90 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -75,7 +75,7 @@ struct dentry *kvm_debugfs_dir;
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 
-bool kvm_rebooting;
+static bool kvm_rebooting;
 
 #ifdef KVM_CAP_DEVICE_ASSIGNMENT
 static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,

