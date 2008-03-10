Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYCJSKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYCJSKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYCJSKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:10:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32664 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYCJSKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:10:38 -0400
Message-ID: <47D57945.60204@oracle.com>
Date: Mon, 10 Mar 2008 11:09:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lwoodman@redhat.com
Subject: Re: [PATCH] sysrq show-all-cpus
References: <20080310133242.0ab69084@bree.surriel.com>	<20080310104628.b70af419.randy.dunlap@oracle.com> <20080310140315.1a451092@bree.surriel.com>
In-Reply-To: <20080310140315.1a451092@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> SysRQ-P is not always useful on SMP systems, since it usually ends up showing the
> backtrace of a CPU that is doing just fine, instead of the backtrace of the CPU
> that is having problems.
> 
> This patch adds SysRQ show-all-cpus(L), which shows the backtrace of every active
> CPU in the system.  It skips idle CPUs because some SMP systems are just too large
> and we already know what the backtrace of the idle task looks like.
>  
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> diff -up linux-2.6.25-rc3-mm1/Documentation/sysrq.txt.multicpu linux-2.6.25-rc3-mm1/Documentation/sysrq.txt
> --- linux-2.6.25-rc3-mm1/Documentation/sysrq.txt.multicpu	2008-03-10 13:49:18.000000000 -0400
> +++ linux-2.6.25-rc3-mm1/Documentation/sysrq.txt	2008-03-10 13:51:09.000000000 -0400
> @@ -85,6 +85,8 @@ On all -  write a character to /proc/sys
>  'k'     - Secure Access Key (SAK) Kills all programs on the current virtual
>            console. NOTE: See important comments below in SAK section.
>  
> +'l'     - Shows a stack backtrace for all active CPUs.
> +
>  'm'     - Will dump current memory info to your console.
>  
>  'n'	- Used to make RT tasks nice-able

Yep, thanks.
A diffstat is also appreciated (in the future).

-- 
~Randy
