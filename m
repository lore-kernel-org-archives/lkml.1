Return-Path: <linux-kernel-owner+w=401wt.eu-S1763076AbXKMUqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763076AbXKMUqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762049AbXKMUpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:45:32 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:61659 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761695AbXKMUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:45:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HALCbOUdMROHU/2dsb2JhbACBWw
Date: Tue, 13 Nov 2007 15:45:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org, bfields@fieldses.org
Subject: Re: stuck nfsd processes with 2.6.24-rc2
Message-ID: <20071113204512.GC7450@Krystal>
References: <alpine.DEB.0.9999.0711131955530.27452@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.9999.0711131955530.27452@sheep.housecafe.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:42:58 up 10 days,  1:48,  5 users,  load average: 1.53, 2.02,
	1.66
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christian Kujau (lists@nerdbynature.de) wrote:
> Hi there,
>
> I noticed that I cannot use kernel nfsd any more with 2.6.24-rc2, last 
> working kernel as of now is 2.6.23.1. First I was using nfsv4 but switching 
> to nfsv3 did not help either: exported shares can be mounted (client: 
> 2.6-git/powerpc32, nfs-common-1.1.1~git-20070709-3ubuntu1), but running "ls 
> /mountpoint" (even without "-l") on the client is enough to get the [nfsd] 
> processes in "D" state.
> Restarting the rpc.nfsd process on the does not help much, the new rpc.nfsd 
> processes get stuck quickly.
>
> For more details please see http://nerdbynature.de/bits/2.6.24-rc2/nfsd/
>
> I haven't seen this particular issue on the list recently, hence my post.
> I'll try to git-bisect my way through the changesets, but it'll take some 
> time...
>

Hrm, sounds like an interesting case for LTTng. Feel free to try it
and get the text dump of the last events that led to the nfsd hang.

See http://ltt.polymtl.ca for the patchset for 2.6.24-rc3-git3,
just follow the quickstart guide to get started.

(the overall process could be faster than a git bisect....)

Mathieu


> Thanks,
> Christian.
> -- 
> BOFH excuse #314:
>
> You need to upgrade your VESA local bus to a MasterCard local bus.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
