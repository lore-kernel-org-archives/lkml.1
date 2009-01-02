Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbZABTmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbZABTmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZABTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:42:12 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:21507 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZABTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:42:11 -0500
Message-ID: <495E6DA2.8060901@oracle.com>
Date: Fri, 02 Jan 2009 11:40:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter W Morreale <pmorreale@novell.com>
CC: linux-kernel@vger.kernel.org, riel@nl.linux.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH v3] Update of Documentation/
References: <20090102193116.8124.22532.stgit@hermosa.site>
In-Reply-To: <20090102193116.8124.22532.stgit@hermosa.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.495E6DA6.00F5:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter W Morreale wrote:
> This patch updates Documentation/sysctl/vm.txt and
> Documentation/filesystems/proc.txt.   More specifically, the section on
> /proc/sys/vm in Documentation/filesystems/proc.txt was removed and a
> link to Documentation/sysctl/vm.txt added.
> 
> Most of the verbiage from proc.txt was simply moved in vm.txt, with new
> addtional text for "swappiness" and "stat_interval".
> 
> This update applies against linux-next-20090102.
> 
> Best,
> -PWM
> ---
> 
> Signed-off-by: Peter W Morreale <pmorreale@novell.com>
> 
>  Documentation/filesystems/proc.txt |  266 ----------------
>  Documentation/sysctl/vm.txt        |  590 +++++++++++++++++++++++++-----------
>  2 files changed, 413 insertions(+), 443 deletions(-)

I get this when trying to apply the patch (using 'patch'), but I don't
see why (yet):


|diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
|index 334ef2f..0a9c66a 100644
|--- a/Documentation/filesystems/proc.txt
|+++ b/Documentation/filesystems/proc.txt
--------------------------
Patching file Documentation/filesystems/proc.txt using Plan A...
Hunk #1 succeeded at 5.
Hunk #2 succeeded at 1373.
Hmm...  The next patch looks like a unified diff to me...
The text leading up to this was:
--------------------------
|diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
|index e9a5c28..9c97c68 100644
|--- a/Documentation/sysctl/vm.txt
|+++ b/Documentation/sysctl/vm.txt
--------------------------
Patching file Documentation/sysctl/vm.txt using Plan A...
Hunk #1 succeeded at 1.
Hunk #2 FAILED at 17.
1 out of 2 hunks FAILED -- saving rejects to file Documentation/sysctl/vm.txt.rej
Hmm...missing header for unified diff at line 603 of patch
  The next patch looks like a unified diff to me...
can't find file to patch at input line 603
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
| 
--------------------------
File to patch:




-- 
~Randy
