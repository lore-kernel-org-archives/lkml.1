Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYHGO5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYHGO5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYHGO5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:57:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:33268 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYHGO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=aXJGWsfnjY+pTj6Sjg3hwe52Dcg7tXvhA50QiVr9ssZ0pvzQS/FVmNNVpo7ZEJice0
         72HtE4toOy1vI5KuE3827YExLAU/tqYCEDOUnlEyX/Ho6F9KaQWIE3wkgS8PyDtoq5mR
         Yzwrzz6SWeTOhPpovhAG3G8SChoP4H7vLWSEI=
Message-ID: <680ad8bc0808070757u49e13b3br1f69fb4881dc44ce@mail.gmail.com>
Date: Thu, 7 Aug 2008 09:57:03 -0500
From: "Matt Parnell" <mparnell@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc0 Power Bugs with HP/Compaq Laptops
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have had a long ongoing ordeal dealing with the problems associated
with the HP Pavilion Laptops, mine being a dv9000 series. It seems
that these either have a broken HPET table, a missing HPET table, or
some other ACPI issue, as this thing has always had many issues
regarding ACPI. First, C1E was broken until I totally disabled it with
a patch, but since .27, that code has been rewritten, and now for some
reason HPET isn't working anymore, as I have to set the
clocksource=tsc. On top of that, the tsc clocksource is unstable, and
with or without dynticks the .27 kernels on my laptop feel slower, and
laggy, as even KDE slows down whilest using it. Everything works fine
if I disable the local apic (lapic), but when I do, only one of my CPU
cores is detected and used, and the CPU frequency scaling doesn't work
either. No matter what I do with .27, it just won't work.

I've tried with the linux next kernel as suggested by Eduard Munteanu,
to no avail with the same problem. He said this:

"This is not the right fix. Instead, HPET should be used as a timer
source for dynticks. This is not in 2.6.26, but I tried the linux-next
tree (google it) and it looked like dynticks worked fine, without
disabling C1E. Can't place my finger on the exact commit, but you could
check."

Apparently, it's either this or something closely related that is
causing such calamity for users of these HP/Compaq laptops as myself.
I say this not just for me, as there are many thousands who have
issues with these laptops and their crappy bios implementations. Most
are n00bs using Ubuntu, who can't even voice what's wrong, as they are
new to linux anyway.

That said, here are system specifics regarding the motherboard and make.

HP Pavilion dv9205us
Motherboard: Quanta 30B7
Processor: AMD Turion 64 x2 3.2ghz, TL-50
Bios: Phoenix (this is known to be buggy, but until now I had no
problems since 2.6.24. Compiled on Windows, this bios is.)

Other than that, I have no pertinent information, at least until
someone asks something specific. I wouldn't be contacting you all if I
wasn't at the end of my own resources, as I am part of the Zen kernel
community, and they can usually help out with these sorts of things.
(zen-sources.org).

Anyway, I appreciate any help/response I can get out of this.

Thanks!
Matt Parnell
