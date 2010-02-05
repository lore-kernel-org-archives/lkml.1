Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab0BEHII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:08:08 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:36900 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247Ab0BEHIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:08:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tBx44aGD4vXi/6VS6aoAaZ5KAkTkgLl8oZq0pFLZ8hec6y6/LLJia0pyNrGBRBmzZI
         DyLI4esw/tzG5Y46B0pQDWdfC8lgmecU7c5mKg2gJS7Por/mRm/zJiQft/fZfvqRCwHc
         UZ10cwKf9emrKjhUkGyEBTJ78fj/TTM67/QGk=
MIME-Version: 1.0
In-Reply-To: <dbcb72f71002041737n421d592eib5dfe9399d69e3b3@mail.gmail.com>
References: <dbcb72f71002041737n421d592eib5dfe9399d69e3b3@mail.gmail.com>
Date: Fri, 5 Feb 2010 09:08:02 +0200
Message-ID: <b6fcc0a1002042308l783c44dcr19bc3325bce15697@mail.gmail.com>
Subject: Re: Oops for 2.6.31.12 BUG: unable to handle kernel paging request
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Fly Emu <emufly@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 3:37 AM, Fly Emu <emufly@gmail.com> wrote:
> BUG: unable to handle kernel paging request at 02930619
> IP: [<c0216ff9>] 0xc0216ff9

> Call Trace:
>  [<c0218009>] ? 0xc0218009
>  [<c022b7ac>] ? 0xc022b7ac
>  [<c021782b>] ? 0xc021782b
>  [<c0535726>] ? 0xc0535726
>  [<c021d864>] ? 0xc021d864
>  [<c021d8aa>] ? 0xc021d8aa
>  [<c021d8e1>] ? 0xc021d8e1
>  [<c0202c95>] ? 0xc0202c95
> Code: 31 f6 e8 81 fe ff ff 89 c3 59 89 d8 89 f2 5b 5b 5e 5f 5d c3 55
> 57 56 53 83 ec 1c 89 44 24 08 8b 68 30 8b 54 24 08 8b 80 9c 03 00 <00>
> 85 ed 89 44 24 04 8b 92 a0 03 00 00 89 14 24 0f 84 fc 00 00
> EIP: [<c0216ff9>]  SS:ESP 0068:de701ee8

Grab vmlinux or System.map and match there adresses to function names
otherwise it's impossible to understand.
And turn CONFIG_DEBUG_BUGVERBOSE on.
