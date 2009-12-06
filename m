Return-Path: <linux-kernel-owner+w=401wt.eu-S933807AbZLFOzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbZLFOzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 09:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbZLFOzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 09:55:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933783AbZLFOzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 09:55:36 -0500
Message-ID: <4B1BC5EA.5040200@redhat.com>
Date: Sun, 06 Dec 2009 09:55:38 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH 2/7] Introduce __page_check_address
References: <20091204173233.5891.A69D9226@jp.fujitsu.com> <20091204174139.5897.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091204174139.5897.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 03:42 AM, KOSAKI Motohiro wrote:
>  From 381108e1ff6309f45f45a67acf2a1dd66e41df4f Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Date: Thu, 3 Dec 2009 15:01:42 +0900
> Subject: [PATCH 2/7] Introduce __page_check_address
>
> page_check_address() need to take ptelock. but it might be contended.
> Then we need trylock version and this patch introduce new helper function.
>
> it will be used latter patch.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
