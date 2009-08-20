Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZHTDHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZHTDHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 23:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZHTDHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 23:07:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49626 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbZHTDHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 23:07:43 -0400
Message-ID: <4A8CBDA9.5060707@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 11:06:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 6/8] Lets ss->can_attach and ss->attach do whole threadgroups
 at a time
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235837.22531.86001.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090818235837.22531.86001.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07:58, Paul Menage wrote:
> From: Ben Blum <bblum@google.com>
> 
> 
> Lets ss->can_attach and ss->attach do whole threadgroups at a time
> 
> This patch alters the ss->can_attach and ss->attach functions to be able to
> deal with a whole threadgroup at a time, for use in cgroup_attach_proc. (This
> is a pre-patch to cgroup-procs-writable.patch.)
> 
> Currently, new mode of the attach function can only tell the subsystem about
> the old cgroup of the threadgroup leader. No subsystem currently needs that
> information for each thread that's being moved, but if one were to be added
> (for example, one that counts tasks within a group) this bit would need to be
> reworked a bit to tell the subsystem the right information.
> 
> Signed-off-by: Ben Blum <bblum@google.com>
> Signed-off-by: Paul Menage <menage@google.com>
> 

Acked-by: Li Zefan <lizf@cn.fujitsu.com>
