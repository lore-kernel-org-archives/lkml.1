Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbZL1GhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbZL1GhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 01:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZL1GhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 01:37:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58030 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbZL1GhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 01:37:02 -0500
Message-ID: <4B385207.8070305@cn.fujitsu.com>
Date: Mon, 28 Dec 2009 14:36:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, Paul Menage <menage@google.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 4/4] cgroups: subsystem module unloading
References: <20091221203253.GA5683@andrew.cmu.edu> <20091221203800.GE5683@andrew.cmu.edu>
In-Reply-To: <20091221203800.GE5683@andrew.cmu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Provides support for unloading modular subsystems.
> 
> From: Ben Blum <bblum@andrew.cmu.edu>
> 
> This patch adds a new function cgroup_unload_subsys which is to be used for
> removing a loaded subsystem during module deletion. Reference counting of the
> subsystems' modules is moved from once (at load time) to once per attached
> hierarchy (in parse_cgroupfs_options and rebind_subsystems) (i.e., 0 or 1).
> 
> It also adds a proper module_delete call in net/sched/cls_cgroup.c.
> 
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

Also please fix comment style and add some blank lines properly.


