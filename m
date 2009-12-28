Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbZL1EM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbZL1EM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 23:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZL1EMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 23:12:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZL1EMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 23:12:25 -0500
Message-ID: <4B383017.4070308@redhat.com>
Date: Sun, 27 Dec 2009 23:12:07 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Prevent churning of zero page
 in LRU list.
References: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop> <4B38246C.3020209@redhat.com> <20091228035639.GG3601@balbir.in.ibm.com> <20091228035738.GH3601@balbir.in.ibm.com>
In-Reply-To: <20091228035738.GH3601@balbir.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2009 10:57 PM, Balbir Singh wrote:
> * Balbir Singh<balbir@linux.vnet.ibm.com>  [2009-12-28 09:26:39]:
>
>> * Rik van Riel<riel@redhat.com>  [2009-12-27 22:22:20]:
>>
>>> On 12/27/2009 09:53 PM, Minchan Kim wrote:
>>>>
>>>> VM doesn't add zero page to LRU list.
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

>> Frequent moving of zero page should ideally put it to the head of the
>> LRU list, leaving it untouched is likely to cause it to be scanned
>> often - no? Should this be moved to the unevictable list?
>>
>
> Sorry, I replied to wrong email, I should have been clearer that this
> question is for Minchan Kim.

The answer to your question is all the way up in
Minchan Kim's original email.

The zero page is never on the LRU lists to begin with.

-- 
All rights reversed.
