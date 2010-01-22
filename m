Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881Ab0AVBMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0AVBMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612Ab0AVBMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:12:13 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:60298 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0AVBMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:12:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aUCrLMV486dUdSpnRX6a+IbS/jfXjH42WCXFkoIKsxQaOptXOrRAAJ1xnqTImM25Uz
         X/WoAoiSv/I4jdTXMpKbIxHJATPPi3ZrJxPQV9+k6Xnj1mE0gPBhfQrY9p91OWB6I4+Z
         6cisSlvKwCqaorvQfUorO7eaP6tXVBc8oqdgU=
MIME-Version: 1.0
In-Reply-To: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com>
References: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com>
Date: Fri, 22 Jan 2010 12:12:08 +1100
Message-ID: <d45a3acc1001211712p6b1a5934xacf5d6b8976f115b@mail.gmail.com>
Subject: Re: Hi all, bug or design flaw?
From: andrew hendry <andrew.hendry@gmail.com>
To: Stepan Chatalyan <kehcho@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks to me like expected behavior using noexec mount option?

On Fri, Jan 22, 2010 at 12:05 PM, Stepan Chatalyan <kehcho@gmail.com> wrote:
> Hi there,
>
> I'm Stepan G. Chatalyan, and i think that I discovered a bug or design
> flaw... and I don't know that it is provide from kernel...
>
> Let's see:
>
> (1) I mount /tmp with noexec,nosuid,nodev options
>
> /dev/hda6 on /tmp type ext3 (rw,noexec,nosuid,nodev,relatime)
>
> (2) I went to 'cd /tmp'`and I created a bash script, or another script
> (perl, python, etc)... and chmod +x createdfile
> script cointain:
>
> #!/bin/bash
> echo "Probe..."
>
> (3) I tried to execut it with "./createdfile"
> [kehcho@kehcho] [/tmp]$ ./createdfile
> -bash: ./createdfile: /bin/bash: bad interpreter: Permission denied
>
> (4) I tried to execute it, but pass to bash ". /tmp/createdfile"
>
> [kehcho@tornadowt] [/tmp]$ . /tmp/createdfile
> Probe...
>
> It is a kernel bug or I just report a another one?
>
> BB
>
> --
> Regards
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
