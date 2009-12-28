Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492AbZL1ERi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbZL1ERi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 23:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZL1ERh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 23:17:37 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60195 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZL1ERh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 23:17:37 -0500
Date: Mon, 28 Dec 2009 09:47:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Prevent churning of zero page in
 LRU list.
Message-ID: <20091228041731.GI3601@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop>
 <4B38246C.3020209@redhat.com>
 <20091228035639.GG3601@balbir.in.ibm.com>
 <20091228035738.GH3601@balbir.in.ibm.com>
 <4B383017.4070308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4B383017.4070308@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2009-12-27 23:12:07]:

> On 12/27/2009 10:57 PM, Balbir Singh wrote:
> >* Balbir Singh<balbir@linux.vnet.ibm.com>  [2009-12-28 09:26:39]:
> >
> >>* Rik van Riel<riel@redhat.com>  [2009-12-27 22:22:20]:
> >>
> >>>On 12/27/2009 09:53 PM, Minchan Kim wrote:
> >>>>
> >>>>VM doesn't add zero page to LRU list.
>      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> >>Frequent moving of zero page should ideally put it to the head of the
> >>LRU list, leaving it untouched is likely to cause it to be scanned
> >>often - no? Should this be moved to the unevictable list?
> >>
> >
> >Sorry, I replied to wrong email, I should have been clearer that this
> >question is for Minchan Kim.
> 
> The answer to your question is all the way up in
> Minchan Kim's original email.
> 
> The zero page is never on the LRU lists to begin with.
>

Aahh.. my bad... I should have looked at it more closely! 

-- 
	Balbir
