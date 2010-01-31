Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949Ab0AaTo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0AaTo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 14:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022Ab0AaTo6
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 14:44:58 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:56979 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0AaTo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 14:44:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LY5NQJLqarawhtlJQ5o9f0KHw4dWprtw4bcYR84xH1f0DXdbk+Z3yvhWJ1CQHuvBnF
         PFP0LMbxDoqB+g0LG6621J9Yi0NoTWnQndxwaxALSjN7yEGB+JBkKs2chqQKqEzaKtI2
         1Ikk0TB9u5efvr6qaxJ/ry/Nxnjqq5FzaLOzo=
MIME-Version: 1.0
In-Reply-To: <4B65A76D.3080508@mandriva.org>
References: <5d75f4611001310715o55674116n436e13e3a5437fc4@mail.gmail.com>
	 <4B65A76D.3080508@mandriva.org>
Date: Mon, 1 Feb 2010 02:44:57 +0700
Message-ID: <5d75f4611001311144q7146ee4axb841bc73d6185c40@mail.gmail.com>
Subject: Re: kernel BUG at fs/dcache.c:670!
From: BuraphaLinux Server <buraphalinuxserver@gmail.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you! The patch fixed the problem for me.  I hope it is included
in 2.6.32.X soon.

On 1/31/10, Thomas Backlund <tmb@mandriva.org> wrote:
> 31.01.2010 17:15, BuraphaLinux Server skrev:
>> Hello list,
>>
>> Is this really a kernel problem, or did I do something stupid?  This
>> is an x86_64 kernel but a 32bit userland.
>>
>
> you need the patch referenced here:
>
> http://lkml.org/lkml/2010/1/28/292
>
> --
> Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
