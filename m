Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZLPCo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZLPCo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZLPCoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:44:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZLPCoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:44:25 -0500
Message-ID: <4B28497A.90606@redhat.com>
Date: Tue, 15 Dec 2009 21:44:10 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Mike Galbraith <efault@gmx.de>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 4/8] Use prepare_to_wait_exclusive() instead prepare_to_wait()
References: <1260855146.6126.30.camel@marge.simson.net> <4B27A417.3040206@redhat.com> <20091216093533.CDF1.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091216093533.CDF1.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2009 07:48 PM, KOSAKI Motohiro wrote:

> if we really need wait a bit, Mike's wake_up_batch is best, I think.
> It mean
>   - if another CPU is idle, wake up one process soon. iow, it don't
>     make meaningless idle.
>   - if another CPU is busy, woken process don't start to run awhile.
>     then, zone_watermark_ok() can calculate correct value.

Agreed, that should work great.

-- 
All rights reversed.
