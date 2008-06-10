Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYFJUc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYFJUc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYFJUcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:32:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:27365 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbYFJUcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Uh2YlCDsDgLJQobm99e3u5KGKBxa5BxWnnQBhKHLzt/Vb/VL1iUt6/UjKnQq+xzJT5
         7JgZTVuF+smFHpfllxgoC9g4WluyeFtDlg8LTUzkjEByRYaJb5WWCDAbpncOQ66wBaBo
         7nMNrE2/ZQbXlT3ZRUivADFIqXPmAIErDhrlQ=
Message-ID: <484EE490.4060509@gmail.com>
Date: Tue, 10 Jun 2008 22:31:12 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com,
       riel@redhat.com
Subject: Re: + mm-only-vmscan-noreclaim-lru-scan-sysctl-fix.patch added to
 -mm tree
References: <200806101837.m5AIbmiO023529@imap1.linux-foundation.org>
In-Reply-To: <200806101837.m5AIbmiO023529@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2008 08:37 PM, akpm@linux-foundation.org wrote:
> Subject: mm-only-vmscan-noreclaim-lru-scan-sysctl-fix
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> build fix
> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Cc: Rik van Riel <riel@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/vmscan.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff -puN mm/vmscan.c~mm-only-vmscan-noreclaim-lru-scan-sysctl-fix mm/vmscan.c
> --- a/mm/vmscan.c~mm-only-vmscan-noreclaim-lru-scan-sysctl-fix
> +++ a/mm/vmscan.c
> @@ -2400,6 +2400,7 @@ static void show_page_path(struct page *
>  		       dentry_path(dentry, buf, 256), pgoff);
>  		spin_unlock(&mapping->i_mmap_lock);
>  	} else {
> +#ifdef CONFG_MM_OWNER

s/CONFG/CONFIG/

>  		struct anon_vma *anon_vma;
>  		struct vm_area_struct *vma;
>  

