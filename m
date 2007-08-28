Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbXH1QZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbXH1QZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXH1QZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:25:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:41738 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751582AbXH1QZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:25:06 -0400
X-Authenticated: #12383568
X-Provags-ID: V01U2FsdGVkX18Uhp4ev6cU7vYhgWsl0jKN0FGtyHinFi/umCpAWE
	ThegsQaZcZzq9I
From: Clemens Kolbitsch <clemens.kol@gmx.at>
To: linux-kernel@vger.kernel.org
Subject: user-mode stack size & location
Date: Tue, 28 Aug 2007 18:25:01 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708281825.01688.clemens.kol@gmx.at>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi!
i'm working on a new concept of i386 memory management and have to change 
quite a bit of the linux mm. could someone please point out, where the 
location & size of the USER-MODE stack is set for a new program (i.e. after 
calling sys_execve...) exactly?

I know that all settings are simply copied from the parent-process when 
invoking fork and how the stack grows (through page-faults).

However,

1.) is

  mm->start_stack

set inside the

  search_binary_handler / the individual fs-handlers?

i see that the aout-, elf-, etc. handlers all set this variable --> is this 
the only location where it can be set?

2.) when looking at /proc/PID/maps, i see that the stack always ends at 
different locations (obviously close to TASK_SIZE). thus the sizes seem to 
vary. where are they set / where are the infos written to the vma's / the 
PGD?

any help would be greatly appreciated!!
greets,
  clemens
