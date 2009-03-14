Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZCNLRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZCNLRg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZCNLRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:17:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:36123 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZCNLRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=x7oZrqJfQEYJbilK8nLSrG9UHvx9LD9Phh5dcmUZPKC5vcvOZsFiGPs+XES7YT2yO/
         4/6riYZkuJD+5dpd8WMwUgXWHgbQqTaWIajZP3jDWjxOYuXs5F7f73mm9FA25nAGeqRJ
         PCuHRSoP+QRKsi3tt2WOseezNIeIdM87oQP7Y=
MIME-Version: 1.0
In-Reply-To: <20090313173348.10169.31420.stgit@warthog.procyon.org.uk>
References: <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
	 <20090313173348.10169.31420.stgit@warthog.procyon.org.uk>
Date: Sat, 14 Mar 2009 20:17:22 +0900
X-Google-Sender-Auth: 9b431dabe1486ef1
Message-ID: <2f11576a0903140417w4caffda9q76e4662c68c6b9fc@mail.gmail.com>
Subject: Re: [PATCH 1/2] NOMMU: There is no mlock() for NOMMU, so don't 
	provide the bits
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Cc: minchan.kim@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, peterz@infradead.org,
       nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
       riel@surriel.com, lee.schermerhorn@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/14 David Howells <dhowells@redhat.com>:
> The mlock() facility does not exist for NOMMU since all mappings are
> effectively locked anyway, so we don't make the bits available when they're
> not useful.
>
> Signed-off-by: David Howells <dhowells@redhat.com>

Oh, your patch is more cleaner way.
Thanks!
   Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
