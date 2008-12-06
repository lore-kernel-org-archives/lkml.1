Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbYLFQIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbYLFQIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 11:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYLFQHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 11:07:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:43457 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbYLFQHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 11:07:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=RjwPs3C+mYbyZytFTrp45lFIj3mjJWSIYtKMlG7FcQDfBqhGiQCPw3Tc3SNKSYDzB0
         QT2QUkNu/WOhBlP/z1Bi5BXByc1aOTiRiDlVtsj5fgt8qssK6sgyhDWbv2gTzpkY3HYJ
         5s5tZ/j4rM0sm5/kXwPE26Z07uHc52Y/PgVg0=
Message-ID: <119aab440812060807i8ca0583pdf9aa3b15bdc54fd@mail.gmail.com>
Date: Sat, 6 Dec 2008 11:07:54 -0500
From: "Carlos O'Donell" <carlos@systemhalted.org>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: IO space memcpy support for userspace.
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       libc-alpha@sources.redhat.com
In-Reply-To: <21d7e9970812052234u58586957y83d618eea295e0f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970812041940h29994c60w3e7bcf20b96efe04@mail.gmail.com>
	 <119aab440812050932h9173a4bm79273b7ea8fe9a3a@mail.gmail.com>
	 <20081205.122238.12303228.davem@davemloft.net>
	 <21d7e9970812052234u58586957y83d618eea295e0f7@mail.gmail.com>
X-Google-Sender-Auth: d2104431546a0acf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 1:34 AM, Dave Airlie <airlied@gmail.com> wrote:
> Its a real pain in the ass with dynamic buffer objects, we don't want userspace
> to care where they are located, the kernel migrates them in/out of
> video memory, GART, local RAM etc.
>
> However I suspect I just need on these platforms to ban any CPU
> accesses to pixmaps in VRAM. However
> sw fallbacks to the front buffer will always need these accesses.
>
> Its going to be a real pain getting any traction this stuff upstream
> (X.org/Mesa) where the world is x86 and maybe the odd powerpc, having
> to do special accessors for shithouse hw is never going to be fun.

Is there no case on x86 when this matters?

What about ARM, ColdFire or MIPS?

As the embedded market continues to grow I hope to see X.org/Mesa on
more hardware with different memory access rules.

Cheers,
Carlos.
