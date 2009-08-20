Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbZHTDBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbZHTDBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 23:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZHTDBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 23:01:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZHTDBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 23:01:46 -0400
Message-ID: <4A8CBC4A.4030502@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 11:00:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 8/8] Adds ability to move all threads in a process to
 a new	cgroup atomically
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235848.22531.152.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090818235848.22531.152.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> From: Ben Blum <bblum@google.com>
> 
> 
> Adds ability to move all threads in a process to a new cgroup atomically
> 
> This patch adds functionality that enables users to move all threads in a
> threadgroup at once to a cgroup by writing the tgid to the 'cgroup.procs'
> file. This current implementation makes use of a per-threadgroup rwsem that's
> taken for reading in the fork() path to prevent newly forking threads within
> the threadgroup from "escaping" while the move is in progress.
> 
> Cgroups subsystems that need to perform per-thread actions in their
> "attach" callback are (currently) responsible for doing their own
> synchronization, since this occurs outside of the critical section
> that locks against cloning within a thread group.
> 
> Signed-off-by: Ben Blum <bblum@google.com>
> Signed-off-by: Paul Menage <menage@google.com>
> 

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

