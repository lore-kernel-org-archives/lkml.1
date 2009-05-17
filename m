Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZEQQCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZEQQCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 12:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZEQQB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 12:01:58 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:45921 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZEQQB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 12:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IeoAuvD1yxNwBthDIPSQtUcTRznL/4PIuXQ8mycolIsVSeo12UgFjkUa/1HRbsdeDf
         99KsRhI3l5M9i/E02VdC8OJwWXgnjS84dHz7G7apHJIa0u9Ee4I13Kgrt8oIkZtG6vhD
         bX5Lv7TLpI2eAaW+dy6dk3Pzb6UZpL1hVNlU8=
MIME-Version: 1.0
In-Reply-To: <19ac3f7a0905170822q28255239nea01b56d52e3ddf8@mail.gmail.com>
References: <19ac3f7a0905170822q28255239nea01b56d52e3ddf8@mail.gmail.com>
Date: Mon, 18 May 2009 01:01:58 +0900
X-Google-Sender-Auth: aac03732fa51e313
Message-ID: <2f11576a0905170901x41e15f65sf10bb5ee36050d14@mail.gmail.com>
Subject: Re: dd if=/dev/random of=data.bin bs=512 count=1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jon Grant <jg@jguk.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello
>
> Issuing this command, I expected to get a file 4096 bytes in size.
> Could someone let me know if I have missed something..? Or is there a
> problem with using /dev/random this way?
>
> if I have a count=10 it hangs forever (several hours).
>
> Changing to use /dev/urandom and it generates the file ok.

you already have the answer. /dev/random might blocked, /dev/urandom doesn't.


> Please include my email address in replies,  as I'm not a member of this list.
>
> Best regards, Jon
>
> $ dd if=/dev/random of=data.bin bs=512 count=1
> 0+1 records in
> 0+1 records out
> 8 bytes (8 B) copied, 4.47366 s, 0.0 kB/s
>
> $ dd --version
> dd (coreutils) 6.10
>
> $ uname -a
> Linux ubuntu 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:57:59 UTC
> 2009 i686 GNU/Linux
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
