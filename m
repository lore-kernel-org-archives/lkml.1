Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZE0MGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZE0MGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZE0MF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:05:56 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:35419 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZE0MFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Nzo5uXeq6yRkusxYBd3oNFKD8AHjVz9yRuWG5pzhsO/srWhPsvE6WtpRYLGJCIuCxH
         JSFK+zbbtdOjMu6yMK+qozbT7lxkCwR8n2wZrjk5KjB2Ui3hesO90nLGlOgjyokEg9q6
         IsEiHnPm7SgMjfDYYVuGFZKbfOh76irnlm9f4=
MIME-Version: 1.0
In-Reply-To: <8763gj7m23.fsf@devron.myhome.or.jp>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	 <87fxfnbytu.fsf@devron.myhome.or.jp>
	 <87ws8zak1m.fsf@devron.myhome.or.jp>
	 <87bpqbaji9.fsf@devron.myhome.or.jp>
	 <18940.9039.850580.48730@samba.org>
	 <87ab5v9381.fsf@devron.myhome.or.jp>
	 <18940.10942.989329.993465@samba.org>
	 <87ocub7ngh.fsf@devron.myhome.or.jp>
	 <18940.12667.429391.927727@samba.org>
	 <8763gj7m23.fsf@devron.myhome.or.jp>
Date: Wed, 27 May 2009 17:35:56 +0530
Message-ID: <ce9ab5790905270505i530febcerfda874f5049c6c93@mail.gmail.com>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
From: vimal singh <vimal.newwork@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: tridge@samba.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any conclusion has been reached reagarding this patch...?

---
vimal

On Sat, May 2, 2009 at 5:29 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> tridge@samba.org writes:
>
>>  > Yes. I guess -ENAMETOOLONG would not good for !valid, and !(is_shortname
>>  > && base_info.valid && ext_info.valid) or add "else" part is more prefer
>>  > though.
>>
>> ok, new patch below.
>
> Looks good to me as technical stand.
>
>>  > Yes. The case-insensitive is ok, the dcache can handle case-insensitive.
>>
>> good, that makes life simpler :-)
>>
>> Are you happy with the shortname_flags hackery in
>> vfat_create_shortname() ?
>
> Ah. What is the intent to force WINNT option (lcase field)? To force it
> may not be good. So, change default if config is on?
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
