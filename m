Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbYGaIK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbYGaIK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYGaIKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:10:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:3337 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYGaIKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Zlfe9tWaV8kkr9tM8UqPSiAFQGTY95EnCSikoPoNS23vr5Xr2pd8ZHwPKwkMBO+7Zc
         8qm3+LZmKErhM90qla4FolTxaNFZZRKSi31yEfzyza4Or84RTWNWnoKYPhdB1ONjpceN
         EEYSB4rEfNTHKGMfqkXbaGPiNyB3Ym4qDoIeg=
Message-ID: <661de9470807310110s33b0032re4c99c4d247047f0@mail.gmail.com>
Date: Thu, 31 Jul 2008 13:40:42 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.27-rc1-mm1
Cc: linux-kernel@vger.kernel.org, "Hugh Dickins" <hugh@veritas.com>,
       "Paul Menage" <menage@google.com>
In-Reply-To: <20080731000354.24b55d5b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080731000354.24b55d5b.akpm@linux-foundation.org>
X-Google-Sender-Auth: c25c1d01070c4f9d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup.patch
> -memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch
> -memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
> -memrlimit-add-memrlimit-controller-accounting-and-control-fix.patch
> -memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
> -memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
>
>  memrlimit patches were folded into other patches.  I guess I'll drop
>  this patch series soon.

Andrew,

Please don't do so. We did discuss this and while Paul and Hugh have
opposed the patches, there is no alternative to memory overcommit
handling for cgroups. Claiming that no one supports overcommit is not
a valid argument. Apache (of what I've seen can decide rlimits for
each of it's children). Without the overcommit feature, a cgroup would
be prone to either excessive swapping for OOM (if badly configured). A
friendly feature that allows us to control and fail allocations is
much nicer.

I've resolved most of the issues reported, except for the last one by
Hugh. The infrastructure also allows me to build a mlock controller. I
am just back from Canada, I hope to get cracking at the problem soon.

Balbir
