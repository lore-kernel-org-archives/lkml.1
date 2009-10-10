Return-Path: <linux-kernel-owner+w=401wt.eu-S1761717AbZJJPgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761717AbZJJPgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761128AbZJJPgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:36:36 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:56744 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbZJJPgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=r2wjByHaOsK2wbIpj5VO6Ws+ZjKnghpsN0WuKASOp8wqQVdPwmavAi6/cjx35nH1ni
         gji6e6+Oub0oIsUzp5Px9tbm/6LdvV61ntrmP2WIzaynkoOCDBaU54UIaOFnyROsrrzP
         WTmaHaeC6Q6H/XeYlUw6lZDW4SossnJARTgRI=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0910090946220.26484@gentwo.org>
References: <20091009100527.1284.A69D9226@jp.fujitsu.com>
	 <20091009100708.1287.A69D9226@jp.fujitsu.com>
	 <20091009174505.12B3.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.1.10.0910090946220.26484@gentwo.org>
Date: Sun, 11 Oct 2009 00:35:58 +0900
X-Google-Sender-Auth: e2e14cc698e37fd2
Message-ID: <2f11576a0910100835t4cba94a9v3ccd7473de229af5@mail.gmail.com>
Subject: Re: [PATCH 2/3] Fix memory leak of never putback pages in mbind()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Oops, I forgot to remove unnecessary brace.
>> updated patch is here.
>
> Thats a style issue. There are other weird things in do_mbind as well
> like starting a new block in the middle of another.
>
> Having
>
> }
> {
>
> in a program is a bit confusing. So could you do a cleanup patch for
> mpol_bind? Preferably it should make it easy to read to and bring some
> order to the confusing error handling.

Yes, I'll do.
