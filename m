Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYJZVkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYJZVkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 17:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYJZVkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 17:40:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:13489 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYJZVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 17:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dUpMCyvdpkCcBCGmiUZc+HHhDdtomPG5e1/KHOl5w6qjaG69jUrlfQKg4LmS0BPIQO
         9sci4PoB9MTAeamBl1LZwJYPFRzMaKj4dE5EfxJb5hrOPHe8cMcxEXV5Icrgqfxg9JdY
         TXiMEiDan5zPdrVTxVH8Oa/f+igjbiXiYC7Yo=
Message-ID: <3aaafc130810261440q1f801a3bv8b74d5629aa1edfc@mail.gmail.com>
Date: Sun, 26 Oct 2008 17:40:04 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: staging: me4000: remove duplicated #include's
Cc: "Greg KH" <greg@kroah.com>, "Huang Weiyi" <weiyi.huang@gmail.com>,
       gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20081026213335.GB1586@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081018113833.61B4.WEIYI.HUANG@gmail.com>
	 <20081020211822.GA30320@kroah.com>
	 <20081026213335.GB1586@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 5:33 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Oct 20, 2008 at 02:18:22PM -0700, Greg KH wrote:
>> On Sat, Oct 18, 2008 at 11:52:15AM +0800, Huang Weiyi wrote:
>> > Removed duplicated #include's in drivers/staging/me4000/me4000.c
>> >    asm/uaccess.h
>> >    linux/fs.h
>> >
>> > Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
>> >
>> > diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
>> > index 862dd7f..90de6f0 100644
>> > --- a/drivers/staging/me4000/me4000.c
>> > +++ b/drivers/staging/me4000/me4000.c
>> > @@ -30,7 +30,6 @@
>> >  #include <asm/uaccess.h>
>> >  #include <linux/errno.h>
>> >  #include <linux/delay.h>
>> > -#include <linux/fs.h>
>> >  #include <linux/mm.h>
>> >  #include <linux/unistd.h>
>> >  #include <linux/list.h>
>> > @@ -39,7 +38,6 @@
>> >  #include <linux/poll.h>
>> >  #include <linux/vmalloc.h>
>> >  #include <asm/pgtable.h>
>> > -#include <asm/uaccess.h>
>> >  #include <linux/types.h>
>> >
>> >  #include <linux/slab.h>
>>
>> Hm, this doesn't apply anymore as some cleanups went in that should have
>> just made this not needed.
>>
>> But if you have a script I can run somewhere to verify it, I'd
>> appreciate it.
>
> linux-2.6$ make help | grep include
>  includecheck    - Check for duplicate included header files
> linux-2.6$

Is there a way to get this to just check in a user-specified
directory? I didn't see any options for that and adding
M=drivers/staging didn't help.

>
>> thanks,
>>
>> greg k-h
>
> cu
> Adrian
>
> --
>
>       "Is there not promise of rain?" Ling Tan asked suddenly out
>        of the darkness. There had been need of rain for many days.
>       "Only a promise," Lao Er said.
>                                       Pearl S. Buck - Dragon Seed
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
