Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbZCPNOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbZCPNOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757989AbZCPNOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:14:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:64485 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596AbZCPNOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qO8g5nqKFwn1vYo83pIIyz9difg/A4+rAlBx03fW1ypU3msQQ4o68RQH6ByVwnbi+f
         RyVbs9h446Gc9ASGsL/HSe+SS3+AkwueN9Qt56Hdlcz7C25j6vaE2Lo6bobRnYmAZr2A
         Kc4srhHqncvaoEgC8bixOcHfuBSDhiaWnl5xc=
MIME-Version: 1.0
In-Reply-To: <28c262360903160555u402b4c34nf273951a207826a2@mail.gmail.com>
References: <20090316105945.18131.82359.stgit@warthog.procyon.org.uk>
	 <20090316120224.GA16506@infradead.org>
	 <20090316211830.1FE8.A69D9226@jp.fujitsu.com>
	 <28c262360903160555u402b4c34nf273951a207826a2@mail.gmail.com>
Date: Mon, 16 Mar 2009 22:14:11 +0900
X-Google-Sender-Auth: 2873c901eb177d85
Message-ID: <2f11576a0903160614n4908d0fdo25df387dd724ac19@mail.gmail.com>
Subject: Re: [PATCH] Point the UNEVICTABLE_LRU config option at the 
	documentation
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
       lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/16 Minchan Kim <minchan.kim@gmail.com>:
> size vmlinux
>   text    data     bss     dec     hex filename
> 6232681  747665  708608 7688954  7552fa vmlinux
>
> size vmlinux.unevictable
>   text    data     bss     dec     hex filename
> 6239404  747985  708608 7695997  756e7d vmlinux.unevictable
>
> It almost increases about 7K.
> Many embedded guys always have a concern about size although it is very small.
> It's important about embedded but may not be about server.

Thanks good report.
this is unintetional size to me. I'll digg it later.

Thanks!


-- kosaki


>
> In addition, CONFIG_UNEVICTABLE_LRU feature don't have a big impact in
> embedded machines which have a very small ram.
> I guess many embedded guys will not use this feature.
>
> So, I don't want to remove this configurable option.
> Lets not add useless size bloat in embedded system.
