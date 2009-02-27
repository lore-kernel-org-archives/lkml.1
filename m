Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZB0KMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZB0KMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZB0KMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:12:32 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:59289 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZB0KMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:12:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OSitzd4FpJoYGV4qnypO8vBvzpysDYI6AEgdnbIdxSeKPUJGYQJBU/qrXzea3hNPIp
         uhCAIzP90oDAbhkooYi2ZcKWortIYfF61qhV0VGzHvFRrWSci1z5UixHjw1YzX2ze/lA
         EWBshgd9iayFZ6wEpoTeLgJjX4JH32heA+Mdo=
Message-ID: <49A7BC89.6040407@gmail.com>
Date: Fri, 27 Feb 2009 11:12:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jiri Slaby <jirislaby@gmail.com>, airlied@linux.ie, eric@anholt.net,
       keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: i915 X lockup
References: <49A7B253.906@gmail.com> <1235728867.24401.82.camel@laptop>
In-Reply-To: <1235728867.24401.82.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.2.2009 11:01, Peter Zijlstra wrote:
> would be good to have sysrq-w output

There was nothing but events. So this is rather an intel driver 
userspace bug?

SysRq : Show Blocked State
   task                        PC stack   pid father
events/1      D 0000000000000000     0    11      2
  ffff8801cb231da0 0000000000000046 ffff8801cb231d00 ffffffff80231ef8
  0000003800000010 0000000000010180 ffff880028053840 ffff880028057180
  ffff8801cb20c790 ffff8801cb20ca38 00000001ca3f90e8 00000000ffff7a0e
Call Trace:
  [<ffffffff80231ef8>] ? dequeue_entity+0x18/0x1a0
  [<ffffffff80230b50>] ? dequeue_task+0xb0/0xf0
  [<ffffffff805fca2a>] __mutex_lock_slowpath+0xea/0x170
  [<ffffffff803f60a0>] ? i915_gem_retire_work_handler+0x0/0x90
  [<ffffffff805fc6f6>] mutex_lock+0x26/0x50
  [<ffffffff803f60d8>] i915_gem_retire_work_handler+0x38/0x90
  [<ffffffff80250792>] worker_thread+0x172/0x250
  [<ffffffff80254da0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff80250620>] ? worker_thread+0x0/0x250
  [<ffffffff802549be>] kthread+0x9e/0xb0
  [<ffffffff8020d3da>] child_rip+0xa/0x20
  [<ffffffff80254920>] ? kthread+0x0/0xb0
  [<ffffffff8020d3d0>] ? child_rip+0x0/0x20
