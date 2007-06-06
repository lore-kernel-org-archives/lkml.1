Return-Path: <linux-kernel-owner+w=401wt.eu-S933746AbXFFSZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbXFFSZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759817AbXFFSZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:25:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37238 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759683AbXFFSZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:25:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
References: <1181146045.9503.67.camel@dyn9047017100.beaverton.ibm.com>
	<m1sl95t3r4.fsf@ebiederm.dsl.xmission.com>
	<1181151475.9503.77.camel@dyn9047017100.beaverton.ibm.com>
Date: Wed, 06 Jun 2007 12:24:11 -0600
In-Reply-To: <1181151475.9503.77.camel@dyn9047017100.beaverton.ibm.com>
	(Badari Pulavarty's message of "Wed, 06 Jun 2007 10:37:55 -0700")
Message-ID: <m18xaxszzo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty <pbadari@us.ibm.com> writes:
>
> ------ Shared Memory Segments --------
> key        shmid      owner      perms      bytes      nattch     status
> 0x00000000 884737     db2inst1  767        33554432   13
> 0x00000000 950275     db2fenc1  701        23052288   13
>
> There is no unique way to identify them easily :(
>
> I guess, like you suggested, we can change the dentry name to use shmid
> instead of the portions of the "key" to make it unique. I think, I can 
> work out a patch for this.

Thanks.  That should be more robust.

Eric
