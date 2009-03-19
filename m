Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbZCSTXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbZCSTXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZCSTX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:23:26 -0400
Received: from mx45.mail.ru ([94.100.176.59]:35000 "EHLO mx45.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbZCSTXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:23:25 -0400
X-Greylist: delayed 1643 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 15:23:25 EDT
From: Peter Lojkin <ia6432@inbox.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.28, limiting cpu time doesn't work
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: unknown via proxy [83.167.111.116]
Date: Thu, 19 Mar 2009 21:34:07 +0300
X-Mru-Data: 2340:1:1:70:70:0
Reply-To: Peter Lojkin <ia6432@inbox.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1LkN4B-0002yU-00.ia6432-inbox-ru@f205.mail.ru>
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

after upgrade to 2.6.28 ulimit -t doesn't work. for example:

bash# ulimit -t 3; cpuhog

(where cpuhog is any program that continuously use cpu)
with 2.6.27.20 cpuhog gets killed after 3sec as expected.
with 2.6.28, 2.6.28.8, 2.6.29-rc8-git4 it's keep running indefinitely.
ulimit -a and /proc/<pid>/limits show that cputime limit was set correctly.

have i missed some global api changes? recompilation of recent glibc with new kernel headers and shell doesn't help...

ps please cc me, i'm not on the list

