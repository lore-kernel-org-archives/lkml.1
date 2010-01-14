Return-Path: <linux-kernel-owner+w=401wt.eu-S932201Ab0ANJ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab0ANJ3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056Ab0ANJ3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:29:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65131 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab0ANJ3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:29:33 -0500
Message-ID: <4B4EE3FF.1090608@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 17:29:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ben Blum <bblum@andrew.cmu.edu>, Vivek Goyal <vgoyal@redhat.com>,
       ryov@valinux.co.jp, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cgroups: blkio subsystem as module
References: <20091231051050.GA714@andrew.cmu.edu> <20100106160414.bd555474.akpm@linux-foundation.org> <20100107012606.GA25577@andrew.cmu.edu> <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com> <4B45824B.9030108@cn.fujitsu.com> <20100108163352.GB22219@redhat.com> <20100112233453.GB5098@unix37.andrew.cmu.edu> <20100112233709.GD5098@unix37.andrew.cmu.edu> <20100114091557.GO13771@kernel.dk>
In-Reply-To: <20100114091557.GO13771@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Jan 12 2010, Ben Blum wrote:
>> Convert blk-cgroup to be buildable as a module
>>
>> From: Ben Blum <bblum@andrew.cmu.edu>
>>
>> This patch modifies the Block I/O cgroup subsystem to be able to be built as a
>> module. As the CFQ disk scheduler optionally depends on blk-cgroup, config
>> options in block/Kconfig, block/Kconfig.iosched, and block/blk-cgroup.h are
>> enhanced to support the new module dependency.
> 
> I'd like to add this for 2.6.34, but I'd like some sign-off(s) on the
> cgroup side of things (for patch 1/2).
> 

Yes, it's for .34. But these 2 patches can't be applied to block-tree,
because the patches that implement cgroup modular feature are in -mm,
and they will go into .34.

