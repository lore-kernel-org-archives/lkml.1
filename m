Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbXBEPHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbXBEPHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 10:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932617AbXBEPHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 10:07:45 -0500
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:2542 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932600AbXBEPHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 10:07:44 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Bodo Eggert <7eggert@gmx.de>
Subject: Re: 2.6.20 doesn't compile with gcc-3.2.2
Date: Mon, 5 Feb 2007 15:07:40 +0000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Al Boldi <a1426z@gawab.com>
References: <Pine.LNX.4.58.0702051441370.3434@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0702051441370.3434@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702051507.40421.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 13:48, Bodo Eggert wrote:
> Al Boldi <a1426z@gawab.com> wrote:
> > Doing the following results in an incomplete vmlinuz:
> >
> > # make bzlilo
> >
> > objcopy: arch/i386/boot/compressed/vmlinux.bin: File truncated
> > make[2]: *** [arch/i386/boot/compressed/vmlinux.bin] Error 1
> > make[1]: *** [arch/i386/boot/compressed/vmlinux] Error 2
> > make: *** [bzlilo] Error 2
> >
> > gcc version 3.2.2 (Mandrake Linux 9.1 3.2.2-3mdk)
>
> I just compiled using gcc 3.3.5 (debian stable). Please verify that your
> disk is not full and gcc is the cause. If it is, this patch should do the
> trick: :)

Not so fast.. post your config? If you've got anything referring to 
relocatable kernel support, try disabling it?

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
