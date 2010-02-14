Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab0BNECc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 23:02:32 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:57256 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0BNECb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 23:02:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LpYLR0j6LwdeeEyfqJopBq9V6nFkR/20PIDAxHFxgcjBAcgOkMDnjxbBJKywJXi9m4
         1VD8ZQUqCl5BsxWGsRuRKCdtvB1/qLUF3Zb3uvl/kmueawMmXDbmRvIyStCS6kan4pw9
         QlfaZ/pRL6tb/0Cf2uTx477BXH7x+TsTUbZY0=
MIME-Version: 1.0
In-Reply-To: <201002140251.59668.volkerarmin@googlemail.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
Date: Sat, 13 Feb 2010 20:02:30 -0800
Message-ID: <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
Subject: Re: Linux mdadm superblock question.
From: Michael Evans <mjevans1983@gmail.com>
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 5:51 PM, Volker Armin Hemmann
<volkerarmin@googlemail.com> wrote:
>>0.90 has a very bad problem, which is that it is hard to distinguish
>>between a RAID partition at the end of volume and a full RAID device.
>>This is because 0.90 doesn't actually tell you the start of the device.
>>
>>Then, of course, there are a lot of limitations on size, number of
>>devices, and so on in 0.90.
>
> but it is the only format supporting autodetection.
>
> So - when will autodetection be introduced with 1.X? And if not, why not?
>
> All I found was 'autodetection might be troublesome' and nothing else.
>  But dealing with initrds is troublesome too. Pure evil even.
>
> Glück Auf,
> Volker
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I remember hearing that 1.x had /no/ plans for kernel level
auto-detection ever.  That can be accomplished in early-userspace
leaving the code in the kernel much less complex, and therefore far
more reliable.

In other words, 'auto-detection' for 1.x format devices is using an
initrd/initramfs.
