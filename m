Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0BCTnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:43:45 -0500
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:62373 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932230Ab0BCTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:43:43 -0500
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Feb 2010 14:43:42 EST
From: Frans Pop <elendil@planet.nl>
To: David Rientjes <rientjes@google.com>
Subject: Re: Improving OOM killer
Date: Wed, 3 Feb 2010 20:29:31 +0100
User-Agent: KMail/1.9.9
Cc: balbir@linux.vnet.ibm.com, riel@redhat.com, l.lunak@suse.cz,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       npiggin@suse.de, jkosina@suse.cz
References: <201002012302.37380.l.lunak@suse.cz> <4B698CEE.5020806@redhat.com> <20100203170127.GH19641@balbir.in.ibm.com> <20100203170127.GH19641@balbir.in.ibm.com> <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com>
In-reply-To: <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002032029.34145.elendil@planet.nl>
X-OriginalArrivalTime: 03 Feb 2010 19:29:34.0535 (UTC) FILETIME=[37580570:01CAA507]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> /*
> * /proc/pid/oom_adj ranges from -1000 to +1000 to either
> * completely disable oom killing or always prefer it.
> */
> points += p->signal->oom_adj;
> 

Wouldn't that cause a rather huge compatibility issue given that the 
current oom_adj works in a totally different way:

! 3.1 /proc/<pid>/oom_adj - Adjust the oom-killer score
! ------------------------------------------------------
! This file can be used to adjust the score used to select which processes
! should be killed in an  out-of-memory  situation.  Giving it a high score
! will increase the likelihood of this process being killed by the
! oom-killer.  Valid values are in the range -16 to +15, plus the special
! value -17, which disables oom-killing altogether for this process.

?

Cheers,
FJP
