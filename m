Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbZIXAom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbZIXAom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZIXAol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:44:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63533 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbZIXAok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:44:40 -0400
Message-ID: <4ABAC0A7.3050307@cn.fujitsu.com>
Date: Thu, 24 Sep 2009 08:43:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update documentation of cgroups tasks and procs files
References: <20090924001249.4783.91619.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090924001249.4783.91619.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Update documentation of cgroups tasks and procs files
> 
> Document the cgroup.procs file.
> 
> Clarify the semantics of the cgroup.procs and tasks files.  Although
> the current cgroup.procs interface returns a sorted and uniqified list
> of pids, potential future performance enhancements could result in
> those properties being removed - explicitly document this aspect of
> the API.
> 
> There are no existing users of cgroup.procs, so compatibility isn't an
> issue.  There are users of the "tasks" file, but none that would
> appear to break in the event of the sorted property being broken. The
> standard "libcpuset" explicitly sorts the results of reading from the
> tasks file, and "libcg" and other users don't appear to care about
> ordering.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
