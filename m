Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285AbZCGFE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbZCGFE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 00:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZCGFEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 00:04:20 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36571 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZCGFET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 00:04:19 -0500
Date: Sat, 7 Mar 2009 10:34:08 +0530
From: prasad@linux.vnet.ibm.com
To: mingo@elte.hu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: [Patch 00/11] Hardware Breakpoint Interfaces
Message-ID: <20090307050408.GA23959@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
        Please find the revised set of patches that implement Hardware
Breakpoint (or watchpoint) registers and an arch-specific implementation
for x86/x86_64.

Changelog
---------
A previous version of these patches were submitted through
http://thread.gmane.org/gmane.linux.kernel/802597. Changes in this
patchset over the previous version include

- Addition of a startup selftest to the ftrace plugin that checks for
  traces after a 'write' operation over a variable registered through
  the plugin for tracing (Patch 11/11).
- A fully-featured reset function - ksym_trace_reset() (Patch 11/11).
- Some of the potential memory leak scenarios identified through the
  comments (Patch 11/11).
- Rebased the patchset against commit
  34bc9c8fa7c868040407cc4822ed517a43792fe8 in -tip tree.

Kindly include them to be a part of -tip tree.

Thanks,
K.Prasad

