Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZLFTlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZLFTlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZLFTlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:41:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbZLFTlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:41:53 -0500
Message-ID: <4B1C0902.1050209@redhat.com>
Date: Sun, 06 Dec 2009 14:41:54 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH 3/7] VM_LOCKED check don't need pte lock
References: <20091204173233.5891.A69D9226@jp.fujitsu.com> <20091204174217.589A.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091204174217.589A.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 03:42 AM, KOSAKI Motohiro wrote:
>  From 24f910b1ac966c21ea5aab825d1f26815b760304 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Date: Thu, 3 Dec 2009 16:06:47 +0900
> Subject: [PATCH 3/7] VM_LOCKED check don't need pte lock
>
> Currently, page_referenced_one() check VM_LOCKED after taking ptelock.
> But it's unnecessary. We can check VM_LOCKED before to take lock.
>
> This patch does it.

Nice optimization.

> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
