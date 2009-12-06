Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbZLFUec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbZLFUec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbZLFUea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:34:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757958AbZLFUe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:34:26 -0500
Message-ID: <4B1C1554.5060007@redhat.com>
Date: Sun, 06 Dec 2009 15:34:28 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH 5/7] Don't deactivate the page if trylock_page() is failed.
References: <20091204173233.5891.A69D9226@jp.fujitsu.com> <20091204174347.58A0.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091204174347.58A0.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 03:44 AM, KOSAKI Motohiro wrote:
>  From 7635eaa033cfcce7f351b5023952f23f0daffefe Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 4 Dec 2009 12:03:07 +0900
> Subject: [PATCH 5/7] Don't deactivate the page if trylock_page() is failed.
>
> Currently, wipe_page_reference() increment refctx->referenced variable
> if trylock_page() is failed. but it is meaningless at all.
> shrink_active_list() deactivate the page although the page was
> referenced. The page shouldn't be deactivated with young bit. it
> break reclaim basic theory and decrease reclaim throughput.
>
> This patch introduce new SWAP_AGAIN return value to
> wipe_page_reference().
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
