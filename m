Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZCLCtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZCLCtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZCLCsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:48:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50807 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZCLCsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:48:54 -0400
Message-ID: <49B8781C.3050609@cn.fujitsu.com>
Date: Thu, 12 Mar 2009 10:49:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] debug cgroup: remove unneeded cgroup_lock
References: <49B869B7.1090108@cn.fujitsu.com> <6599ad830903111943u2799333dh680470f9daa6ccbb@mail.gmail.com>
In-Reply-To: <6599ad830903111943u2799333dh680470f9daa6ccbb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Mar 11, 2009 at 6:47 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Since we are in cgroup write handler, so the cgrp is valid, so we
>> don't have to hold cgroup_mutex when calling cgroup_task_count().
>> One similar example is in cgroup_tasks_open().
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Acked-by: Paul Menage <menage@google.com>
> 
> (Although this conflicts with a patch that I'm about to send out that
> moves the code from cgroup_debug.c into cgroup.c to allow internal
> details to be reported in the debug.* files.)
> 

or let cgroup.c #include <cgroup_debug.c> ?

