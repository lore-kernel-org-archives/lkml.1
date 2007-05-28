Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbXE1BNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbXE1BNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbXE1BNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:13:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:50684 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbXE1BNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:13:07 -0400
Date: Sun, 27 May 2007 18:17:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dhowells@redhat.com, holt@sgi.com, alan@lxorguk.ukuu.org.uk,
       masami.hiramatsu.pt@hitachi.com, yumiko.sugita.yf@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: Re: [PATCH 7/7] documentation for /proc/pid/coredump_filter
Message-Id: <20070527181729.e9e6d57c.randy.dunlap@oracle.com>
In-Reply-To: <4656E0D7.1090301@hitachi.com>
References: <4656DBFB.2050501@hitachi.com>
	<4656E0D7.1090301@hitachi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 22:12:55 +0900 Kawai, Hidehiro wrote:

> This patch adds the documentation for /proc/<pid>/coredump_filter.
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> ---
>  Documentation/filesystems/proc.txt |   38 +++++++++++++++++++++++++++
>  1 files changed, 38 insertions(+)
> 
> Index: linux-2.6.22-rc2-mm1/Documentation/filesystems/proc.txt
> ===================================================================
> --- linux-2.6.22-rc2-mm1.orig/Documentation/filesystems/proc.txt
> +++ linux-2.6.22-rc2-mm1/Documentation/filesystems/proc.txt
> @@ -42,6 +42,7 @@ Table of Contents
>    2.12	/proc/<pid>/oom_adj - Adjust the oom-killer score
>    2.13	/proc/<pid>/oom_score - Display current oom-killer score
>    2.14	/proc/<pid>/io - Display the IO accounting fields
> +  2.15	/proc/<pid>/coredump_filter - Core dump filtering settings

Looks good.  Just one typo below.

 ------------------------------------------------------------------------------
>  Preface
> @@ -2135,4 +2136,41 @@ those 64-bit counters, process A could s
>  More information about this can be found within the taskstats documentation in
>  Documentation/accounting.
>  
> +2.15 /proc/<pid>/coredump_filter - Core dump filtering settings
> +---------------------------------------------------------------
> +When a process is dumped, all anonymous memory is written to a core file as
> +long as the size of the core file isn't limited. But sometimes we don't want
> +to dump some memory segments, for example, huge shared memory. Conversely,
> +sometimes we wnat to save file-backed memory segments into a core file, not

                want

> +only the individual files.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
