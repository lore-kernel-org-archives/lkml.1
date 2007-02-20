Return-Path: <linux-kernel-owner+w=401wt.eu-S932763AbXBTCO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbXBTCO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 21:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbXBTCO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 21:14:26 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42400 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763AbXBTCOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 21:14:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] make ipc/shm.c:shm_nopage() static
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<20070220000753.GF13958@stusta.de>
Date: Mon, 19 Feb 2007 19:13:44 -0700
In-Reply-To: <20070220000753.GF13958@stusta.de> (Adrian Bunk's message of
	"Tue, 20 Feb 2007 01:07:53 +0100")
Message-ID: <m1mz3960fb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>>...
>> Changes since 2.6.20-rc6-mm3:
>>...
>> +shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
>>...
>>  Misc
>>...
>
>
> shm_nopage() can become static.

Acked-by: Eric W. Biederman <ebiederm@xmission.com>


>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
> --- linux-2.6.20-mm2/ipc/shm.c.old	2007-02-18 22:58:03.000000000 +0100
> +++ linux-2.6.20-mm2/ipc/shm.c	2007-02-18 22:58:18.000000000 +0100
> @@ -226,8 +226,8 @@
>  	mutex_unlock(&shm_ids(ns).mutex);
>  }
>  
> -struct page *shm_nopage(struct vm_area_struct *vma, unsigned long address,
> -			int *type)
> +static struct page *shm_nopage(struct vm_area_struct *vma,
> +			       unsigned long address, int *type)
>  {
>  	struct file *file = vma->vm_file;
>  	struct shm_file_data *sfd = shm_file_data(file);
