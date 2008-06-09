Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYFIEso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYFIEso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 00:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYFIEse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 00:48:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:33029 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYFIEse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 00:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dMXViPzJeZgG8GpUBfEIF7IbSHnOLbC3WA89NZeBtrA+2ubM0/9n9gfXxeAzHnrEQZ
         5KVvJH8YEHZw3roiVyG18C4X4eEs3S6hMz5ZMxrRL6zzAjnqG+QwH2nAbK6ThzevESXj
         Db89TYpN094uhHzr2MdJQY0tRr+petKRl7xHg=
Message-ID: <eada2a070806082148r51cc4417u97062017b522825e@mail.gmail.com>
Date: Sun, 8 Jun 2008 21:48:31 -0700
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
To: npiggin@suse.de
Subject: Re: [patch 3/7] mm: speculative page references
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
In-Reply-To: <20080605094825.699347000@nick.local0.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605094300.295184000@nick.local0.net>
	 <20080605094825.699347000@nick.local0.net>
X-Google-Sender-Auth: 5e7d752ddfe43898
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 2:43 AM,  <npiggin@suse.de> wrote:
> --- linux-2.6.orig/mm/vmscan.c
> +++ linux-2.6/mm/vmscan.c
> @@ -390,12 +390,10 @@ static pageout_t pageout(struct page *pa
>  }
>
>  /*
> - * Attempt to detach a locked page from its ->mapping.  If it is dirty or if
> - * someone else has a ref on the page, abort and return 0.  If it was
> - * successfully detached, return 1.  Assumes the caller has a single ref on
> - * this page.
> + * Save as remove_mapping, but if the page is removed from the mapping, it
> + * gets returned with a refcount of 0.

       ^^^^^^

Same as?
