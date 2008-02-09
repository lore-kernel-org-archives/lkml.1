Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYBIOLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYBIOLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 09:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYBIOLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 09:11:45 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:39941 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856AbYBIOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 09:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=E6pD1CTw063Ndix3hXAad8weQnAvjCOCf1eBcSmGYrmdvapKUnY6QE0lGNxd17yVastMfyXD31pqMTk4ydiZJY+npfcPV65eAONAXqSBcd4Fhq7I/KM7i3f5Ch+pbJnCnCm4g81PM0OzcbU9he3XfOZjzvpVVK9F1m9lJp76Blo=
Message-ID: <f77718aa0802090611n240bfa5avbbe2abeb53607f48@mail.gmail.com>
Date: Sat, 9 Feb 2008 19:41:41 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080130011550.GA31853@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080130011550.GA31853@elte.hu>
X-Google-Sender-Auth: d31e37cd66416a5a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 6:45 AM, Ingo Molnar <mingo@elte.hu> wrote:

> - PIE/brk randomization. Not a single regression happened due to this so
>   far (and it's been in x86.git for months) - it seems exec-shield has
>   rooted out stuff years ago - but we'll see. Details in the patch. It's
>   easily revertable in any case.

cc503c1b "x86: PIE executable randomization" doesn't boot on my Ubuntu
Feisty Fawn Intel Core2 system.

I get numerous segfaults before getting a (initramfs) busybox shell. A
similar bug was reported much earlier:

http://lkml.org/lkml/2007/7/20/421

Sadly, reverting this (or all of the PIE patches) results in a lot of
conflicts now with git-revert too failing, mainly in
arch/x86/mm/mmap_64.c.

-- 
Amit Shah
http://www.amitshah.net/
