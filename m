Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbZL1GeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbZL1GeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 01:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZL1GeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 01:34:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55970 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbZL1GeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 01:34:19 -0500
Message-ID: <4B385164.9070704@cn.fujitsu.com>
Date: Mon, 28 Dec 2009 14:34:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 3/4] cgroups: net_cls as module
References: <20091221203253.GA5683@andrew.cmu.edu> <20091221203704.GD5683@andrew.cmu.edu>
In-Reply-To: <20091221203704.GD5683@andrew.cmu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Allows the net_cls cgroup subsystem to be compiled as a module
> 
> From: Ben Blum <bblum@andrew.cmu.edu>
> 
> This patch modifies net/sched/cls_cgroup.c to allow the net_cls subsystem to
> be optionally compiled as a module instead of builtin. The cgroup_subsys
> struct is moved around a bit to allow the subsys_id to be either declared as a
> compile-time constant by the cgroup_subsys.h include in cgroup.h, or, if it's
> a module, initialized within the struct by cgroup_load_subsys.
> 
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

But can we reorder this patch as the last patch?


