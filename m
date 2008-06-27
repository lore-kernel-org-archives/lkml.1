Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYF0Ok3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYF0Ok3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbYF0OkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:40:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:36997 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbYF0OkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z/K8ozexjIGnRfwpeIvLjB8+6IWGMChBJHHAjts2ev35bQlfFSSHwyiu/9nGhhNxNa
         DBCiH84UQ0cDhK9vHWJxquvSsUXbdscMV1E8bfQirj3SJ7XQ2LxbE4Q+zYxdD2nJR/Wq
         X63XOpk9QFfvLacHU01NC1YH0oLudMggoQ+x4=
Message-ID: <cfd18e0f0806270740v23e0e0e4jc7ca520dcf31540f@mail.gmail.com>
Date: Fri, 27 Jun 2008 16:40:18 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] cpusets: document proc status cpus and mems allowed lists
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Menage" <menage@google.com>, linux-kernel@vger.kernel.org,
       "Mike Travis" <travis@sgi.com>
In-Reply-To: <20080627140528.3490.86690.sendpatchset@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080627140528.3490.86690.sendpatchset@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 4:05 PM, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
> Provide a little documentation for the two new fields,
> Cpus_allowed_list and Mems_allowed_list, that were
> added to each /proc/<pid>/status file a while back.
>
> Signed-off-by: Paul Jackson <pj@sgi.com>

Acked-by: Michael Kerrisk <mtk,manpages@gmail.com>

> ---
>  Documentation/cpusets.txt |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> --- 2.6.26-rc5-mm3.orig/Documentation/cpusets.txt       2008-06-27 06:20:55.000000000 -0700
> +++ 2.6.26-rc5-mm3/Documentation/cpusets.txt    2008-06-27 06:55:34.609862065 -0700
> @@ -154,13 +154,15 @@ browsing and modifying the cpusets prese
>  new system calls are added for cpusets - all support for querying and
>  modifying cpusets is via this cpuset file system.
>
> -The /proc/<pid>/status file for each task has two added lines,
> +The /proc/<pid>/status file for each task has four added lines,
>  displaying the tasks cpus_allowed (on which CPUs it may be scheduled)
>  and mems_allowed (on which Memory Nodes it may obtain memory),
> -in the format seen in the following example:
> +in the two formats seen in the following example:
>
>   Cpus_allowed:   ffffffff,ffffffff,ffffffff,ffffffff
> +  Cpus_allowed_list:      0-127
>   Mems_allowed:   ffffffff,ffffffff
> +  Mems_allowed_list:      0-63
>
>  Each cpuset is represented by a directory in the cgroup file system
>  containing (on top of the standard cgroup files) the following
>
> --
>                          I won't rest till it's the best ...
>                          Programmer, Linux Scalability
>                          Paul Jackson <pj@sgi.com> 1.650.933.1373
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
