Return-Path: <linux-kernel-owner+w=401wt.eu-S1751680AbZGXFXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbZGXFXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 01:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZGXFXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 01:23:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62697 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZGXFXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 01:23:16 -0400
Message-ID: <4A6944E6.1090405@cn.fujitsu.com>
Date: Fri, 24 Jul 2009 13:21:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Allow cgroup hierarchies to be created with no bound
 subsystems
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com> <20090722195045.7481.62013.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090722195045.7481.62013.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Allow cgroup hierarchies to be created with no bound subsystems
> 
> This patch removes the restriction that a cgroup hierarchy must have
> at least one bound subsystem.  The mount option "none" is treated as
> an explicit request for no bound subsystems.
> 
> A hierarchy with no subsystems can be useful for plain task tracking,
> and is also a step towards the support for multiply-bindable
> subsystems.
> 
> As part of this change, the hierarchy id is no longer calculated from
> the bitmask of subsystems in the hierarchy (since this is not
> guaranteed to be unique) but is allocated via an ida.  Reference
> counts on cgroups from css_set objects are now taken explicitly one
> per hierarchy, rather than one per subsystem.
> 
> Example usage:
> 
> mount -t cgroup -o none,name=foo cgroup /mnt/cgroup
> 
> Based on the "no-op"/"none" subsystem concept proposed by
> kamezawa.hiroyu@jp.fujitsu.com
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

