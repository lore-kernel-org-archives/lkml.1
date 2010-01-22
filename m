Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775Ab0AVCAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab0AVCAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640Ab0AVCAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:00:17 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58922 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0AVCAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:00:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S1wcvtO6vOV9Hnda23GxOvLgUWwwRAerFr43cntiUXYo840XTuhhTdkVXNpsXcxtZr
         M22V4ogo50ESCYVTq43Aihj9PpPEc55pLbE8TxKbUPpnwSUiWZCM9EnyZh/BgxufEhqd
         +dqngKceVe9lBDIvKU1JxwHFIv1dr2b0b7LJ0=
MIME-Version: 1.0
In-Reply-To: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com>
References: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com>
Date: Fri, 22 Jan 2010 10:00:15 +0800
Message-ID: <5c7d4fb81001211800k2bf2025bqea45a78292da2199@mail.gmail.com>
Subject: Re: Hi all, bug or design flaw?
From: Shu Wu <superwushu@gmail.com>
To: Stepan Chatalyan <kehcho@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, buddy, this is not the right place to raise a user-space
question. But as for your question, you'd better to learn what the "."
means. "#!/bin/bash" is used to indicate in shell when executed, while
to be just a comment in the latter.

2010/1/22 Stepan Chatalyan <kehcho@gmail.com>:
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
