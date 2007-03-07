Return-Path: <linux-kernel-owner+w=401wt.eu-S1750935AbXCGL7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbXCGL7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXCGL7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:59:55 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41488 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXCGL7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:59:51 -0500
Message-ID: <45EEA8DA.6060006@linux.vnet.ibm.com>
Date: Wed, 07 Mar 2007 17:28:18 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Shane <ibm-main@tpg.com.au>
CC: riel@redhat.com, vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net,
       balbir@in.ibm.com, linux-kernel@vger.kernel.org, xemul@sw.ru,
       linux-mm@kvack.org, menage@google.com, devel@openvz.org,
       clameter@sgi.com
Subject: Re: [ckrm-tech] [PATCH 3/3][RFC] Containers: Pagecache controller
 reclaim
References: <20070305145237.003560000@linux.vnet.ibm.com> > <20070305145311.247699000@linux.vnet.ibm.com> > <1173178212.4998.54.camel@localhost.localdomain> <45ED4CF7.7030501@linux.vnet.ibm.com> <1173258239.4998.79.camel@localhost.localdomain>
In-Reply-To: <1173258239.4998.79.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Shane wrote:
> On Tue, 2007-03-06 at 16:43 +0530, Vaidyanathan Srinivasan wrote:
>> Please let me know if so see any problem running the patch.  The
>> patches are against 2.6.20 only since dependent patches are at that level.
> 
> My problem - a bad copy of the patch. It patches o.k.
> However, it fails to compile vmscan. This looks a bit dodgy;
> 
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> @@ -1470,11 +1494,13 @@ unsigned long shrink_all_memory(unsigned
>         int pass;
>         struct reclaim_state reclaim_state;
>         struct scan_control sc = {
> -               .gfp_mask = GFP_KERNEL,
> +               .gfp_mask = GFdefined(CONFIG_CONTAINER_PAGECACHE_ACCT)
> +P_KERNEL,
> 
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> I deleted what looks like an over-enthusiastic "copy-and-paste", and it
> compiled o.k.
> Testing continues.

OOPS!! How did it get there!  That is certainly some random mouse
click.  Thanks for pointing that out.

--Vaidy


