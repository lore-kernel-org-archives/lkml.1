Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbZKDTSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbZKDTSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbZKDTSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:18:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbZKDTSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:18:51 -0500
Date: Wed, 4 Nov 2009 14:18:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 20/20] blkio: Drop the reference to queue once the task
	changes cgroup
Message-ID: <20091104191837.GK2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-21-git-send-email-vgoyal@redhat.com> <x494opat8cr.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x494opat8cr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 02:09:40PM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > o If a task changes cgroup, drop reference to the cfqq associated with io
> >   context so that upon next request arrival we will allocate a  new queue in
> >   new group.
> 
> You're doing more than dropping the reference, you're also setting the
> pointer in the cic to NULL.  This is what you need to do, of course, but
> your changelog is misleading (and sounds incomplete, and sends off
> alarms in my head).
> 

Will enrich changelog in next version.

Thanks
Vivek
