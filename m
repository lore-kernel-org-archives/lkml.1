Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbZEFJza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbZEFJza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZEFJzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:55:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41084 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZEFJzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:55:20 -0400
Message-ID: <4A015C69.7010600@redhat.com>
Date: Wed, 06 May 2009 12:46:17 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses registrations.
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <4A00DD4F.8010101@redhat.com>
In-Reply-To: <4A00DD4F.8010101@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Izik Eidus wrote:
>> subjects say it all.
>
> Not a very useful commit message.
>
> This makes me wonder, though.
>
> What happens if a user mmaps a 30MB memory region, registers it
> with KSM and then unmaps the middle 10MB?

User cant break 30MB into smaller one.
That mean that when you regisiter memory region that is X mb size, you 
can only remove it (as a whole), or add new region.
This should answer the next question you had about why i have just the 
start address for removing the regions.

>
>> Signed-off-by: Izik Eidus <ieidus@redhat.com>
>
> except for the commit message, Acked-by: Rik van Riel <riel@redhat.com>
>

