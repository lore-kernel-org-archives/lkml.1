Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577Ab0A2BTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab0A2BTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 20:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756568Ab0A2BTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 20:19:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab0A2BTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 20:19:10 -0500
Message-ID: <4B623757.7090001@redhat.com>
Date: Thu, 28 Jan 2010 20:18:15 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       aarcange@redhat.com
Subject: Re: [PATCH -mm] change anon_vma linking to fix multi-process server
 	scalability issue
References: <20100128002000.2bf5e365@annuminas.surriel.com>	 <1264696641.17063.32.camel@barrios-desktop>	 <4B61C83A.20301@redhat.com> <28c262361001281655x70e5f77awf4d890d20f57ca83@mail.gmail.com>
In-Reply-To: <28c262361001281655x70e5f77awf4d890d20f57ca83@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 07:55 PM, Minchan Kim wrote:
> On Fri, Jan 29, 2010 at 2:24 AM, Rik van Riel<riel@redhat.com>  wrote:

>> What am I overlooking?
>
> I also look at the code more detail and found me wrong.
> In mprotect case 6,  the importer is fixed as head of vmas while next
> is marched
> on forward. So anon_vma_clone is just called once at first time.
> So as what you said, It's no problem.
> Totally, my mistake. Sorry for that, Rik.

No problem.  I spent about a day and a half with a few pieces
of paper going over all this code, before deciding how to code
this :)

-- 
All rights reversed.
