Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbZDIH3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbZDIH3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 03:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbZDIH3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 03:29:20 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:65257 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbZDIH3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 03:29:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mzmwxfiYIJSfBKoKYnNig3i/rQ71o2hIxZNuEMTKZwRT9/Zd0JGvNWi19g22OwKEf3
         7yPwGRLL1Kijt0t712R6kPp571z3jzhFqIgXkCXVCjpO80jo543JuLhwlZjS6LOXrNsC
         IJxP3phOU1C0N3cFq/V1EgNzCEZS29NJHWdXo=
MIME-Version: 1.0
In-Reply-To: <20090409003308.GK16602@bilbo.ozlabs.org>
References: <20090408003921.GA5054@ldl.fc.hp.com>
	 <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com>
	 <20090407225457.86f8a458.akpm@linux-foundation.org>
	 <20090409003308.GK16602@bilbo.ozlabs.org>
Date: Thu, 9 Apr 2009 09:29:17 +0200
X-Google-Sender-Auth: 80b57b92929c4239
Message-ID: <10f740e80904090029j15451862ne6479d20ac704991@mail.gmail.com>
Subject: Re: cross-compilers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 9, 2009 at 02:33, Tony Breeds <tony@bakeyournoodle.com> wrote:
> On Tue, Apr 07, 2009 at 10:54:57PM -0700, Andrew Morton wrote:
>> We would benefit very much from having someone who actually maintains a
>> suite of cross-compilers for kernel developers.
>
> I build wont say maintain many of the cross compilers used for linux-next.  I
> can place them somehere.  They're kernel only as I don't build libc.

Any chance m68k-unknown-linux-gnu-gcc 4.0.2 can be updated, so we get proper
m68k allmodconfig coverage again? Recently we had some allmodconfig breakage
in mainline (not limited to m68k though) for stuff that had been in
-next, but was
never tried with m68k allmodconfig due to the ICE, while I could reproduce it.

Mine is gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21), so
far no ICEs
when not trying randconfig (strange that randconfig triggers those).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
