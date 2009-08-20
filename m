Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZHTCgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZHTCgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZHTCgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:36:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55933 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbZHTCgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:36:14 -0400
Message-ID: <4A8CB64D.8070507@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 10:34:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2/8] Adds a read-only "procs" file similar to "tasks"
 that	shows only unique tgids
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235817.22531.23434.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090818235817.22531.23434.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07:58, Paul Menage wrote:
> From: Ben Blum <bblum@google.com>
> 
> 
> Adds a read-only "procs" file similar to "tasks" that shows only unique tgids
> 
> struct cgroup used to have a bunch of fields for keeping track of the pidlist
> for the tasks file. Those are now separated into a new struct cgroup_pidlist,
> of which two are had, one for procs and one for tasks. The way the seq_file
> operations are set up is changed so that just the pidlist struct gets passed
> around as the private data.
> 
> Interface example: Suppose a multithreaded process has pid 1000 and other
> threads with ids 1001, 1002, 1003:
> $ cat tasks
> 1000
> 1001
> 1002
> 1003
> $ cat cgroup.procs
> 1000
> $
> 
> Signed-off-by: Ben Blum <bblum@google.com>
> Signed-off-by: Paul Menage <menage@google.com>
> 

Acked-by: Li Zefan <lizf@cn.fujitsu.com>
