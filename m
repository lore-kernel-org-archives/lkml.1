Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbZHaPlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbZHaPlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZHaPlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:41:12 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:22887 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbZHaPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:41:08 -0400
Date: Mon, 31 Aug 2009 08:39:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Josh Triplett <josh@joshtriplett.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Chris Wright <chrisw@redhat.com>, Izik Eidus <ieidus@redhat.com>
Subject: Re: [PATCH] pagemap: document KPF_KSM and show it in page-types
Message-Id: <20090831083911.715b630b.randy.dunlap@oracle.com>
In-Reply-To: <20090831071702.GB26634@localhost>
References: <20090808173900.GA21009@feather>
	<20090812065107.GA16363@localhost>
	<20090831135720.5E53.A69D9226@jp.fujitsu.com>
	<20090831065659.GA18039@localhost>
	<20090831071425.GA26634@localhost>
	<20090831071702.GB26634@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A9BEEA4.0165:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009 15:17:02 +0800 Wu Fengguang wrote:

> It indicates to the system admin that processes mapping such pages may be
> eating less physical memory than the reported numbers by legacy tools.
> 
> CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> CC: Chris Wright <chrisw@redhat.com>
> CC: Izik Eidus <ieidus@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  Documentation/vm/pagemap.txt |    4 ++++
>  tools/vm/page-types.c        |    2 ++
>  2 files changed, 6 insertions(+)
> 
> --- linux-mm.orig/Documentation/vm/pagemap.txt	2009-08-31 15:02:55.000000000 +0800
> +++ linux-mm/Documentation/vm/pagemap.txt	2009-08-31 15:05:02.000000000 +0800
> @@ -59,6 +59,7 @@ There are three components to pagemap:
>      18. UNEVICTABLE
>      19. HWPOISON
>      20. NOPAGE
> +    21. KSM
>  
>  Short descriptions to the page flags:
>  
> @@ -93,6 +94,9 @@ Short descriptions to the page flags:
>  20. NOPAGE
>      no page frame exists at the requested address
>  
> +21. KSM
> +    identical memory pages dynamicly shared between one or more processes

                              dynamically

> +
>      [IO related page flags]
>   1. ERROR     IO error occurred
>   3. UPTODATE  page has up-to-date data
> --- linux-mm.orig/tools/vm/page-types.c	2009-08-31 15:00:24.000000000 +0800
> +++ linux-mm/tools/vm/page-types.c	2009-08-31 15:02:10.000000000 +0800
> @@ -49,6 +49,7 @@
>  #define KPF_UNEVICTABLE		18
>  #define KPF_HWPOISON		19
>  #define KPF_NOPAGE		20
> +#define KPF_KSM			21
>  
>  /* [32-] kernel hacking assistances */
>  #define KPF_RESERVED		32
> @@ -97,6 +98,7 @@ static char *page_flag_names[] = {
>  	[KPF_UNEVICTABLE]	= "u:unevictable",
>  	[KPF_HWPOISON]		= "X:hwpoison",
>  	[KPF_NOPAGE]		= "n:nopage",
> +	[KPF_KSM]		= "x:ksm",
>  
>  	[KPF_RESERVED]		= "r:reserved",
>  	[KPF_MLOCKED]		= "m:mlocked",


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
