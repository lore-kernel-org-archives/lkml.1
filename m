Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbZFONyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbZFONyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZFONyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:54:17 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:47478 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZFONyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rRpCXohg7PNxU+vtnft5yPJafBHccqJOn+nuRw1lLljj1FV6XWhav4shBj+ppZbF6Y
         o1gu0laLJT2KGWGO4qUONjHsfCPIDa8NxYI1ax+VMQMXGH0FYw91LUyu48lPwsQKF6Bg
         Be2eCcnjzNoGzT/proXTFBPOz943pLfbw/0P0=
MIME-Version: 1.0
In-Reply-To: <20090615064618.120a2337@tlielax.poochiereds.net>
References: <20090615133222.7405743c.sfr@canb.auug.org.au>
	 <20090615064618.120a2337@tlielax.poochiereds.net>
Date: Mon, 15 Jun 2009 08:47:12 -0500
Message-ID: <524f69650906150647y15f4b6e2w3ce2df97064fb95b@mail.gmail.com>
Subject: Re: linux-next: cifs tree build failure
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-cifs-client@lists.samba.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,
I just applied and reviewed your patch 5 (thus modified your patch
slightly before merging).

https://mail.google.com/mail/?shva=1#search/cifs_show_address/121cfb7757cb8e86

On Mon, Jun 15, 2009 at 5:46 AM, Jeff Layton<jlayton@redhat.com> wrote:
> On Mon, 15 Jun 2009 13:32:22 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>> Hi Steve,
>>
>> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>>
>> fs/cifs/cifsfs.c: In function 'cifs_show_options':
>> fs/cifs/cifsfs.c:357: error: implicit declaration of function 'cifs_show_address'
>>
>> Caused by commit 8616e0fc1e27295316f9821a883f0e9fa6f8200f ("cifs: remove
>> unneeded NULL checks from cifs_show_options").
>>
>> I have used the cifs tree from next-20090612 for today.
>
> My fault. That function gets introduced in a later patch and I had a
> bogus call left in here from when I reorganized the series. This
> patch should fix it and a typo that got silently fixed in a patch that
> hasn't been committed yet.
>
> This patch should fix both. Steve F., let me know if you want me to
> respin the series on top of this patch. Note that there's still a
> harmless compiler warning that gets fixed in a later patch in the
> series.
>
> Thanks,
> --
> Jeff Layton <jlayton@redhat.com>
>



-- 
Thanks,

Steve
