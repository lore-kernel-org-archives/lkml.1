Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbZLFUcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbZLFUcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbZLFUb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:31:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbZLFUb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:31:58 -0500
Message-ID: <4B1C14BD.1030202@redhat.com>
Date: Sun, 06 Dec 2009 15:31:57 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH 4/7] Replace page_referenced() with wipe_page_reference()
References: <20091204173233.5891.A69D9226@jp.fujitsu.com> <20091204174253.589D.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091204174253.589D.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 03:43 AM, KOSAKI Motohiro wrote:
>  From d9110c2804a4b88e460edada140b8bb0f7eb3a18 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 4 Dec 2009 11:45:18 +0900
> Subject: [PATCH 4/7] Replace page_referenced() with wipe_page_reference()
>
> page_referenced() imply "test the page was referenced or not", but
> shrink_active_list() use it for drop pte young bit. then, it should be
> renamed.
>
> Plus, vm_flags argument is really ugly. instead, introduce new
> struct page_reference_context, it's for collect some statistics.
>
> This patch doesn't have any behavior change.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
