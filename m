Return-Path: <linux-kernel-owner+w=401wt.eu-S933541AbXDGAA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbXDGAA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933546AbXDGAA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:00:29 -0400
Received: from 163.sub-75-209-152.myvzw.com ([75.209.152.163]:42396 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933541AbXDGAA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:00:28 -0400
Message-Id: <20070406224152.556848893@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Apr 2007 15:41:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 0/4] Clean up asm/bugs.h, identify_cpu() and update COMPAT_VDSO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Four patches:
 - clean up asm/bugs.h, by moving all the C code into its own C file
 - split identify_cpu() into boot and secondary variants, so that
   boot-time setup functions can be marked __init
 - repost of the COMPAT_VDSO patches with a bit more robustness from
   unknown DT_tags, and functions marked __init, since all this is
   boot-time only setup.

Thanks,
	J

-- 

