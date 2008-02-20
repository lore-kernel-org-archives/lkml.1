Return-Path: <linux-kernel-owner+w=401wt.eu-S1764052AbYBTCuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764052AbYBTCuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYBTCuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:50:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42127 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbYBTCuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:50:14 -0500
Date: Wed, 20 Feb 2008 11:48:41 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: kosaki.motohiro@jp.fujitsu.com, Pavel Machek <pavel@ucw.cz>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, marcelo@kvack.org, daniel.spang@gmail.com,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org, a1426z@gawab.com,
       jonathan@jonmasters.org, zlynx@acm.org
In-Reply-To: <20080219210739.27325078@bree.surriel.com>
References: <20080219222828.GB28786@elf.ucw.cz> <20080219210739.27325078@bree.surriel.com>
Message-Id: <20080220114317.642F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik

> > Sounds like a job for memory limits (ulimit?), not for OOM
> > notification, right?
> 
> I suspect one problem could be that an HPC job scheduling program
> does not know exactly how much memory each job can take, so it can
> sometimes end up making a mistake and overcommitting the memory on
> one HPC node.
> 
> In that case the user is better off having that job killed and
> restarted elsewhere, than having all of the jobs on that node
> crawl to a halt due to swapping.
> 
> Paul, is this guess correct? :)

Yes.
Fujitsu HPC middleware watching sum of memory consumption of the job
and, if over-consumption happened, kill process and remove job schedule.

I think that is common hpc requirement.
but we watching to user defined memory limit, not swap.

Thanks.


