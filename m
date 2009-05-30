Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbZE3Kry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbZE3Kry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbZE3Krr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:47:47 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41518 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbZE3Krq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:47:46 -0400
Date: Sat, 30 May 2009 16:17:40 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>
Subject: [Patch 00/12] Hardware Breakpoint interfaces
Message-ID: <20090530104739.GA9512@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,
	Please find a new iteration of the patchset that includes the following
changes over the previous version posted here: http://lkml.org/lkml/2009/5/21/143.

Changelog
----------

- Includes a minor change in Patch 8/12 that renames a variable from 'temp'
  to 'bp_info'.

- Updated comment in __switch_to() function to reflect the new method used
  to detect lazy debug register switching (Patch 6/12).

- Moved the patch that removes 'debugreg<n>' members from 'struct thread_struct'
  to Patch 8/12 in order to enable compilation of the kernel tree after
  application of every patch in the patchset.

Kindly integrate the patchset into -tip tree. They are based on commit
0a834a9c61bb279327c50300e43ebb6de7e1e0d7 of the same tree.

Thanks,
K.Prasad

