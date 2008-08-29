Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbYH2XNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbYH2XNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYH2XM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:12:56 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:54402 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYH2XM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:12:56 -0400
Date: Fri, 29 Aug 2008 16:12:55 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jiayingz@google.com, dkegel@google.com
Subject: [PATCH 0/6] support valgrinding uml
Message-ID: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches enables Valgrind to produce useful results for
User Mode Linux.  Valgrind requires some patches as well.  A list of
the limitations and a recipe for building and using everything can be
found on this page: http://uml.jfdi.org/uml/Wiki.jsp?page=ValgrindingUML

  Documentation/uml/valgrind-suppressions |   95
  arch/um/Makefile                        |    4
  arch/um/include/valgrind.h              |   12
  arch/um/kernel/physmem.c                |   21
  arch/um/kernel/process.c                |   31
  arch/um/kernel/skas/process.c           |    3
  arch/um/os-Linux/skas/process.c         |    7
  include/asm-um/thread_info.h            |    8
  include/linux/memcheck.h                |  285 ++
  include/linux/sched.h                   |    6
  include/linux/valgrind.h                | 3928 ++++++++++++++++++++++++++++++++
  lib/Kconfig.debug                       |   20
  mm/page_alloc.c                         |    4
  mm/slab.c                               |   20
  mm/vmalloc.c                            |   15
  15 files changed, 4456 insertions(+), 3 deletions(-)

--
Steve
