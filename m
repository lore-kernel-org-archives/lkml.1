Return-Path: <linux-kernel-owner+w=401wt.eu-S1762504AbXEWGqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762504AbXEWGqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbXEWGqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:46:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800AbXEWGqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:46:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
X-Fcc: ~/Mail/utrace
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current utrace breaks UML
In-Reply-To: Jeff Dike's message of  Tuesday, 22 May 2007 17:38:31 -0400 <20070522213831.GB10293@c2.user-mode-linux.org>
X-Windows: the art of incompetence.
Message-Id: <20070523064611.3BD151F8510@magilla.localdomain>
Date: Tue, 22 May 2007 23:46:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This chunk from linux-2.6-utrace.patch breaks PTRACE_SYSEMU, which UML
> rather relies on.

PTRACE_SYSEMU and PTRACE_SYSEMU_SINGLESTEP are implemented in a different
way (see kernel/ptrace.c), which does not require that assembly code.  
(It also works for free on other arch's if you want to #define the
constants there.)

Do you have a test case for PTRACE_SYSEMU that does not work right?


Thanks,
Roland
