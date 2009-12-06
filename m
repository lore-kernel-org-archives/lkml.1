Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbZLFVD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbZLFVD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbZLFVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:03:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757634AbZLFVD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:03:57 -0500
Message-ID: <4B1C1C3F.5050309@redhat.com>
Date: Sun, 06 Dec 2009 16:03:59 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH 7/7] Try to mark PG_mlocked if wipe_page_reference find
 VM_LOCKED vma
References: <20091204173233.5891.A69D9226@jp.fujitsu.com> <20091204174544.58A6.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091204174544.58A6.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 03:46 AM, KOSAKI Motohiro wrote:
>  From 519178d353926466fcb7411d19424c5e559b6b80 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 4 Dec 2009 16:51:20 +0900
> Subject: [PATCH 7/7] Try to mark PG_mlocked if wipe_page_reference find VM_LOCKED vma
>
> Both try_to_unmap() and wipe_page_reference() walk each ptes, but
> latter doesn't mark PG_mlocked altough find VM_LOCKED vma.
>
> This patch does it.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
