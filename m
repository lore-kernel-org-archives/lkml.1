Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbXLDPyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbXLDPyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXLDPyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:54:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbXLDPyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:54:32 -0500
Message-ID: <475576A0.5020601@redhat.com>
Date: Tue, 04 Dec 2007 13:47:44 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com
Subject: Re: [PATCH 0/10] Integrate msr.h
References: <11967666042130-git-send-email-gcosta@redhat.com> <20071204140939.GA16328@elte.hu>
In-Reply-To: <20071204140939.GA16328@elte.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar escreveu:
> * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
> 
>> Hello,
>>
>> This series of patches integrates msr.h header. What it really does, 
>> is a series of steps to allow us to get rid of duplicate code between 
>> i386 and x86_64 versions
>>
>> With this done, achieving paravirt for x86_64 gets really easy, just a 
>> couple of extra code.
> 
> thanks, the patches look certainly sane and i've picked them up into 
> x86.git. A quick build & boot test was successful on both 64-bit and 
> 32-bit, with paravirt on/off. I've pushed out the latest tree into the 
> 'mm' branch of:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-x86.git
> 
> minor nit: some of your patches had scripts/checkpatch.pl failures, 
> could you try to fix them up? (If possible then as a follow-up second 
> patch series.) Thanks!
Sure. I'll resend them.

> [ btw., how far away are you from having Kconfig selectable 64-bit
>   paravirt support? Just curious :-) ]
> 
Not too much. Jeremy is handling the page table code, and I'm basically
taking care of the rest. I don't go to far in integration in other
areas, so the patches are the same that were already previously sent
some days ago. I'll just rebase and send again.

The only rebase I'm expecting to be troublesome is the paravirt.c /
paravirt.h files. So I'd say we're close.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHVXagjYI8LaFUWXMRAhHjAKDVDesU/iRyDXDgQB6Pxx23PTizyQCgzzcU
rZsECAdjqaGeZqAxWY2lhro=
=qrHF
-----END PGP SIGNATURE-----
