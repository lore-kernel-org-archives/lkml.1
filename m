Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0BAQfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:35:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab0BAQfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:35:13 -0500
Message-ID: <4B670258.6060109@redhat.com>
Date: Mon, 01 Feb 2010 11:33:28 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       aarcange@redhat.com
Subject: Re: [PATCH -mm] rmap: move exclusively owned pages to own anon_vma
 in do_wp_page
References: <20100128002000.2bf5e365@annuminas.surriel.com>	 <20100128014357.54428c8a@annuminas.surriel.com> <1265037918.20322.32.camel@barrios-desktop>
In-Reply-To: <1265037918.20322.32.camel@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 10:25 AM, Minchan Kim wrote:

>> Signed-off-by: Rik van Riel<riel@redhat.com>
> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>
>
> Let me have a question for my understanding.
>
> Still, don't we have a probability of O(N) in case of parent's page
> at worst case?

Yes, we do.

However, this can only happen for 1/N pages.

Having O(N) for every page can totally bog down a system,
but only running into that worst case every 1/N pages should
make things run OK again.

-- 
All rights reversed.
