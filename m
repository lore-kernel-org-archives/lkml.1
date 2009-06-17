Return-Path: <linux-kernel-owner+w=401wt.eu-S934065AbZFQO33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbZFQO33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763585AbZFQO3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:29:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:16671 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbZFQO3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RKxuGHQdmc62jG/affROgBATHuK4zkome01/KNrUF/3tylrZPd/v0cjSwshOEqZwuz
         /I9alGqvIFI6VYDDYPSA9TyTn3iG4bBf/5KNoA3xUF8bArAdqS4PJ6lcWJP3rjx1luvM
         NBVPCnmkOk7LQaLKrbKt73ghCufKJVDc0ie9s=
Subject: Re: [PATCH]io_apic.c: fix compile warning
From: "Figo.zhang" <figo1802@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090617152846.72804bae@lxorguk.ukuu.org.uk>
References: <1245248720.3312.27.camel@myhost>
	 <20090617152846.72804bae@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Jun 2009 22:29:18 +0800
Message-Id: <1245248958.3312.28.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 15:28 +0100, Alan Cox wrote:
> On Wed, 17 Jun 2009 22:25:20 +0800
> "Figo.zhang" <figo1802@gmail.com> wrote:
> 
> > fix compile warning:
> > arch/x86/kernel/apic/io_apic.c: In function ‘ioapic_write_entry’:
> > arch/x86/kernel/apic/io_apic.c:466: warning: ‘eu’ is used uninitialized in this function
> > arch/x86/kernel/apic/io_apic.c:465: note: ‘eu’ was declared here
> 
> What compiler are you using. Current gcc correctly notices that there are
> no uninitialized things to worry about ?

hi Alan:
my gcc is:

[figo@myhost linux-2.6]$ gcc -v
Using built-in specs.
Target: i686-pc-linux-gnu
Configured with: ../configure --prefix=/usr --enable-shared
--enable-languages=c,c++,fortran,objc,obj-c++ --enable-threads=posix
--mandir=/usr/share/man --infodir=/usr/share/info --enable-__cxa_atexit
--disable-multilib --libdir=/usr/lib --libexecdir=/usr/lib
--enable-clocale=gnu --disable-libstdcxx-pch --with-tune=generic
Thread model: posix
gcc version 4.4.0 20090526 (prerelease) (GCC) 
[figo@myhost linux-2.6]$ 



Best Regards,
Figo.zhang

