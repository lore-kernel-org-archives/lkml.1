Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZLNOrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZLNOrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZLNOrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:47:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbZLNOrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:47:46 -0500
Message-ID: <4B264FE9.4060901@redhat.com>
Date: Mon, 14 Dec 2009 09:47:05 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 7/8] Use TASK_KILLABLE instead TASK_UNINTERRUPTIBLE
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com> <20091214213145.BBC3.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091214213145.BBC3.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 07:32 AM, KOSAKI Motohiro wrote:
> When fork bomb invoke OOM Killer, almost task might start to reclaim and
> sleep on shrink_zone_begin(). if we use TASK_UNINTERRUPTIBLE, OOM killer
> can't kill such task. it mean we never recover from fork bomb.
>
> This patch fixes it.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

As with patch 4/8 I am not convinced that wake_up_all is
the correct thing to do.

Other than that:

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
