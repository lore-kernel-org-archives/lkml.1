Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYK1JDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYK1JDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYK1JDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:03:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57327 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYK1JDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:03:34 -0500
Message-ID: <492FB3FB.6060806@cn.fujitsu.com>
Date: Fri, 28 Nov 2008 17:03:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 1/2] cgroups: cleanup for dummy root
References: <492F9D4C.2020204@cn.fujitsu.com>
In-Reply-To: <492F9D4C.2020204@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> - Don't link rootnode to the root list, so root_list contains active
>   hierarchies only as the comment indicates.
> 
> - Don't link css_sets to the dummy cgroup, because we never want to
>   run through the tasks in that dummpy cgroup (which means run
>   through all the tasks in the system).
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Hmmm...Sorry, this patch is wrong, when a subsystem is inactive thus in
rootnode, it may still iterate tasks in dummy top cgroup, though currently
no subsystem does so.

