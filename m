Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYJUA5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYJUA5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYJUA5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:57:46 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63530 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYJUA5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:57:45 -0400
Message-Id: <200810210057.m9L0vQ7i012829@www262.sakura.ne.jp>
Subject: */ in string confuses checkpatch.pl
From: penguin-kernel@i-love.sakura.ne.jp
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Oct 2008 09:57:26 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The below code confuses checkpatch.pl ver 0.21.

Regards.
----------
# cat /tmp/foo.c
void foo(void)
{
	bar(\" /proc/\\\\*/\");
	bar(\" /proc/\\\\$/\");
}
# /usr/src/vanilla/linux-2.6.27.2/scripts/checkpatch.pl --file /tmp/foo.c
ERROR: need consistent spacing around \'/\' (ctx:WxV)
#4: FILE: tmp/foo.c:4:
+       bar(\" /proc/\\\\$/\");
              ^

total: 1 errors, 0 warnings, 5 lines checked

/tmp/foo.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
