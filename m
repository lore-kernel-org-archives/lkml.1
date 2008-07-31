Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbYGaWuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbYGaWuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbYGaWuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:50:01 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:20217 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbYGaWuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sOQ8aINudKg4kCHRc8nBgAEWNg2a6gmxcuqiH0owAzEPIgS1v9nhbGfMS6GvZeq6Zd
         xKgcUJr/3IVmidw8VmOfIAA6v2kMHo9bkniJ7oc7DpzEp0LZAfoAGgNK4Ag+Y15m8BVa
         wPY3ovj6Xir1cQP9RhTX3fPKUq+xKePTi7URc=
From: Andrea Righi <righi.andrea@gmail.com>
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com
Cc: Matt Heaton <matt@bluehost.com>, Mark Seger <Mark.Seger@hp.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/4] task IO accounting: per block device IO statistics
Date: Fri,  1 Aug 2008 00:49:55 +0200
Message-Id: <1217544599-8935-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new file /proc/<pid>/blockio (and equivalently per-thread
/proc/<pid>/task/<tid>/blockio files) to export per block device i/o statistics
of each process to userspace applications.

The objective of this patch is to provide an efficient method to quickly
identify the top i/o consumers on specific block devices and, more in general,
to collect more detailed informations about specific block device usage.

See the documentation (PATCH 1/4) for more information.

Tested against 2.6.27-rc1-mm1.

The all-in-one patch can be found at:
http://download.systemimager.org/~arighi/linux/patches/task-io-acct-block/

-Andrea
