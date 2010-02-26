Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965602Ab0BZR4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:56:45 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42941 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965482Ab0BZR4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:56:44 -0500
Date: Fri, 26 Feb 2010 19:56:42 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
       vegard.nossum@gmail.com
Subject: [GIT PULL] kmemcheck fixes for 2.6.34-rc1
Message-ID: <alpine.DEB.2.00.1002261954430.30581@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Vegard has been rather quiet recently so I've picked up kmemcheck until he 
returns. Here's a small kmemcheck/kmemleak integration fixlet from Catalin 
Marinas.

                         Pekka

The following changes since commit 6ebdc661b608671e9ca572af8bb42d58108cc008:
   Linus Torvalds (1):
         Merge branch 'next-devicetree' of git://git.secretlab.ca/git/linux-2.6

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git kmemcheck-for-linus

Catalin Marinas (1):
       kmemcheck: Test the full object in kmemcheck_is_obj_initialized()

Pekka Enberg (1):
       Merge branch 'kmemcheck/fixes' into kmemcheck-for-linus

  arch/x86/mm/kmemcheck/kmemcheck.c |    2 +-
  arch/x86/mm/kmemcheck/shadow.c    |   16 ++++++++++++++--
  arch/x86/mm/kmemcheck/shadow.h    |    2 ++
  3 files changed, 17 insertions(+), 3 deletions(-)
