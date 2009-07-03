Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZGCLyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZGCLyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 07:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZGCLyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 07:54:23 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:58356 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZGCLyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 07:54:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=kuY7tAO00T5IMJ9zYNZkK/B/zLt0bBBU7oVcR1jBDa0KhNKVuzNDeJNTJkVMB40pmi
         AGz/+2qxS1if3rEaetfpUgI3TNU7xMzILhtOQm5YmaUdRop/4fBQAC+SOGZ/7Lp2cBNv
         bEaNIuknJbJJP1/pUT65Rxx1Kn2Xixh6GISXo=
MIME-Version: 1.0
Date: Fri, 3 Jul 2009 12:54:25 +0100
Message-ID: <f4527be0907030454q290fe99t73161a0fd6c1d4d2@mail.gmail.com>
Subject: Errors in OSS Sound Blaster driver / DMA Documentation (KERN_WARN)
From: Andrew Lyon <andrew.lyon@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While investigating a compile failure of Xen kernel I noticed that the
OSS Sound Blaster driver and DMA Documentation have the same problem,
KERN_WARNING Is valid and declared in include/linux/kernel.h,
KERN_WARN does not exist, here are the affected files:

Documentation/DMA-mapping.txt:          printk(KERN_WARN "%s: Playback
disabled due to DMA limitations.\n",
Documentation/DMA-mapping.txt:          printk(KERN_WARN "%s: Record
disabled due to DMA limitations.\n",
arch/x86/kernel/cpu/common-xen.c:               printk(KERN_WARN
"Unable to register CSTAR callback\n");
sound/oss/sb_common.c:                          /* printk(KERN_WARN
"Sound Blaster: Unexpected interrupt\n"); */
sound/oss/sb_common.c:                          /* printk(KERN_WARN
"Sound Blaster: Unexpected interrupt\n"); */
sound/oss/sb_ess.c:                     /* printk(KERN_WARN "ESS:
Unexpected interrupt\n"); */

Andy
