Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYJULZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYJULZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 07:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYJULZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 07:25:13 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49963 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbYJULZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 07:25:12 -0400
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: asterisk-slash sequence in quoted string confuses checkpatch.pl
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200810212025.FCC73959.OJVHMOLOFFSQtF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 21 Oct 2008 20:25:09 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Reposting since the webmail system broke the code by adding backslashes. ]

Hello.

The below code confuses checkpatch.pl ver 0.21.

Regards.
----------
# cat /tmp/foo.c
void foo(void)
{
	bar(" /proc/\\*/");
	bar(" /proc/\\$/");
}
# /usr/src/vanilla/linux-2.6.27.2/scripts/checkpatch.pl --file /tmp/foo.c
ERROR: need consistent spacing around '/' (ctx:WxV)
#4: FILE: tmp/foo.c:4:
+       bar(" /proc/\\$/");
              ^

total: 1 errors, 0 warnings, 5 lines checked

/tmp/foo.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
