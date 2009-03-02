Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZCBCMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZCBCMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZCBCMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:12:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63139 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZCBCMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:12:34 -0500
Message-ID: <49AB40BF.4030706@cn.fujitsu.com>
Date: Mon, 02 Mar 2009 10:13:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 0/4] cgroups: show correct file mode
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now a cgroup subsystem can set default file mode of its control files,
so here is a patchset to correct file mode of each subsystem's files.

Should be applied after:
	cgroup-allow-subsys-to-set-default-mode-of-its-own-file.patch

[PATCH 1/4] cgroup debug: show correct file mode
[PATCH 2/4] cpuacct: show correct file mode
[PATCH 3/4] devcgroup: show correct file mode
[PATCH 4/4] cpuset: show correct file mode

