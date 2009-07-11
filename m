Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbZGKCt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbZGKCt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 22:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZGKCts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 22:49:48 -0400
Received: from mail.samba.org ([66.70.73.150]:47296 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZGKCtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 22:49:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19031.64942.968563.614697@samba.org>
Date: Sat, 11 Jul 2009 12:49:18 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       Jamie Lokier <jamie@shareable.org>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, Paul.McKenney@us.ibm.com
Subject: VFAT patent workaround - patches and tree on kernel.org
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to everyone for the lively debate on this patch. If nothing
else it has served to highlight the issue of whether the Linux kernel
should incorporate patent workarounds. The open debate on this has
been very valuable I think.

Thank you also to Hirofumi-san for taking the time to consider my
proposed patch. It was an exhausting debate, and I appreciate the
effort that Hirofumi-san has put in to read through such complex
arguments.

I have created a directory on kernel.org containing the patch, and a
README which documents the interoperability concerns that were raised
during the discussion of the patch:

  http://kernel.org/pub/linux/kernel/people/tridge/VFAT/

I have also created a git tree incorporating the patch, based on the
fatfs-2.6 tree:

  http://git.kernel.org/?p=linux/kernel/git/tridge/fatfs-dualnames.git

Hirofumi-san, could you look at
04f4db5202d2d3ec9b8e780b913c1f1dd3881745 in my tree and consider that
separately for inclusion in your tree?

The patch is also available here:

  http://git.kernel.org/?p=linux/kernel/git/tridge/fatfs-dualnames.git;a=commitdiff;h=04f4db5202d2d3ec9b8e780b913c1f1dd3881745

I will continue to try to address the technical concerns that have
been raised. I appreciate the testing that has been done by many
people on this list, and I hope that testing will continue. 

If I am able to make substantial progress on the technical issues that
have been raised then I will re-submit the patch for consideration for
inclusion in the upstream kernel.

Cheers, Tridge
