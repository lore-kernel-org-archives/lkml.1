Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZAEDTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZAEDTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZAEDTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:19:04 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52537 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZAEDTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:19:01 -0500
Message-Id: <200901050318.n053Iu0L068557@www262.sakura.ne.jp>
Subject: [regression 2.6.27.10 & 2.6.28] \"nolapic\" option causes \"nosmp\"?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Jan 2009 12:18:56 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 05012009 #1398071, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Adding "nolapic" option to kernel command line causes /proc/cpuinfo to show
only 1 CPU, while the machine has 2 CPUs and the kernel was compiled with
CONFIG_SMP=y.

Something is wrong with CPU recognition/initialization code?

This topic is continued from http://lkml.org/lkml/2008/12/30/104 .
I confirmed that this problem occurs on native Ubuntu 8.04 (i386) and
native CentOS 5.2 (x86_64) on ThinkPad X60 (Core 2 Duo).

Kernel 2.6.26.8 seems to be OK.

Regards.
