Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYELVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYELVlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYELVlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:41:37 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58042 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbYELVlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:41:36 -0400
To: linux-kernel@vger.kernel.org
Subject: Kernel hangs in SMP + VMware environment.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200805130641.CDG56299.QStFOLVOOJFHMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 13 May 2008 06:41:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm experiencing hang up problem with recent kernels in VMware environment.

Here are two examples.

http://I-love.SAKURA.ne.jp/tmp/messages.1 (203kB)
http://I-love.SAKURA.ne.jp/tmp/messages.2 (1.7MB)

The messages.1 is a log when "tar" stopped processing
while extracting a .tar.bz2 file by
"rpmbuild -bb --target i586 --with baseonly kernel.spec".
I got this log in runlevel 3 of Fedora 8.

The messages.2 is a log when the compiler processes (e.g. "cc1")
seem to be hanged up (no compiler messages appear for minutes,
which unlikely happen).
I got this log in runlevel 1 of Fedora 8
by "rpmbuild -bb --target i586 --with baseonly kernel.spec"
after starting rsyslog and stopping anacron.

I experience this problem in many distro (e.g. Fedora, Ubuntu, SuSE),
which use kenel (I think) around 2.6.21 and later.

I experience this problem only in VMware.
I have never experienced this problem in native environment.

I experience this problem only when I assign 2 CPUs to VMware.
I have never experienced this problem with 1 CPU.

May be something scheduler related in SMP + VMware environment.

The a.out process in the log files are http://lkml.org/lkml/2008/5/12/130
What other information should I dump for identifying the location of hang up?

Regards.
