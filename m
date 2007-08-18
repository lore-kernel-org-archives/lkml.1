Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbXHRUBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbXHRUBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 16:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759034AbXHRUBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 16:01:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:41917 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759037AbXHRUBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 16:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K4sERG12f4yEkHjvQNhHTWs+ue5yt98eNWxJCwXdvE6Z4wGd53iRet3VBZ2cZOqfaO/nWjz9IjJzBdylAvacG17me6UlgcTPorImeRH3a0VzuMxtraYafwBZCtEeF6jfzbEaDBCH9VchIiqeAYP4CsnLTPT6q3r6UfXarPsLj4s=
Message-ID: <ab40e9c0708181301x5338dc61v33e885f96457e662@mail.gmail.com>
Date: Sat, 18 Aug 2007 22:01:34 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: how to add debug information into the vmlinux
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708182152350.5186@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0708171349n73e35f58p5f5c092b54ddeb45@mail.gmail.com>
	 <9a8748490708171430u2be506canf640d5c8c97149c6@mail.gmail.com>
	 <ab40e9c0708181249l7389c300sd68964e22bf262a9@mail.gmail.com>
	 <Pine.LNX.4.64.0708182152350.5186@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this vmlinux file is running on my software virtual prototype system.
and my software enviorment can only load elf file, so I am using this
real vmlinux file.

regards,

Yang

2007/8/18, Jan Engelhardt <jengelh@computergmbh.de>:
>
> On Aug 18 2007 21:49, Xu Yang wrote:
> >
> >I tried as what you told me. and the vmlinux does contain debug
> >information. but the start address of this vmlinux is 0xc0008000. when
> >I tried to run this vmlinux, the program always exit at 0x80a0. I
> >checked out that here is the place mmu is turned on.
> >so I used objcopy --change-addresses 0x40000000 to change the start
> >address of the vmlinux, and the program goes further.but the debug
> >information disappeared.
>
> Are you using an UML image... or were you really trying to gdb a real vmlinux?
>
>
>
>        Jan
> --
>
