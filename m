Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXHJOyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXHJOyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759957AbXHJOxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:53:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:64085 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbXHJOxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:53:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=qncRv396jAPinW94Jz5j9wSrauw5Ita6ZULQmw5rS3Jns54yb/tbtlsnD2KjSs22FKMcsMaMY5GHdFNendc/T2yTfvVW5PYLkSJPHLqDK8ZZZTJ+jXQzTD0dkRIZTRZSs/HCny7jMZcHU3cmc3vJWsIxNLCh3Xab9O41xeNnF+E=
Message-ID: <46BC7BDA.3000305@googlemail.com>
Date: Fri, 10 Aug 2007 16:53:14 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org>
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton pisze:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm2/
> 
[..]
> +sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
> +sysctl-factor-out-sysctl_data.patch
> +sysctl-error-on-bad-sysctl-tables.patch
> +sysctl-update-sysctl_check_table.patch
> +sysct-mqueue-remove-the-binary-sysctl-numbers.patch
> +sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
> +sysctl-fix-neighbour-table-sysctls.patch
> +sysctl-ipv6-route-flushing-kill-binary-path.patch
> +sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
> +sysctl-x86_64-remove-unnecessary-binary-paths.patch
> +sysctl-remove-broken-cdrom-binary-sysctls.patch
> +sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
> +sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
> 
>  sysctl cleanups

There is something wrong with sysctl

[   25.120741] sysctl_check_dir: failed: /kernel  ref: /kernel .1
[   25.127102] sysctl table check failed: /kernel  Writable sysctl directory
[   25.134157] sysctl table check failed: /kernel  Inconsistent directory names
[   25.141477] sysctl table check failed: /kernel/sched_domain  Writable sysctl directory
[   25.149755] sysctl table check failed: /kernel/sched_domain/cpu0  Writable sysctl directory
[   25.158529] sysctl table check failed: /kernel/sched_domain/cpu0/domain0  Writable sysctl directory
[   25.168102] sysctl table check failed: /kernel/sched_domain/cpu1  Writable sysctl directory
[   25.176862] sysctl table check failed: /kernel/sched_domain/cpu1/domain0  Writable sysctl directory

Eric?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
