Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbZCaCvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbZCaCvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZCaCvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:51:14 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:25289 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbZCaCvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ojpFiivpzE7J1UF8JxP+Q/wmzUOZIC3/Qny5yBuiDxya4L+VkVORdkm4usK3ug42c8
         Tc/GgMLbf7smi2miVtPG2DsVXexXmiNgZoMfkYQGWMLLnHbEggPcg1lDwEOoWDgG4YgV
         go/beqjRmCdH787xoDMCnbHTtLcihdI7oD9JE=
MIME-Version: 1.0
In-Reply-To: <aec7e5c30903250156v1eb38bd7qafe1c4236d9daef@mail.gmail.com>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
	 <20090316193010.56644165@mjolnir.ossman.eu>
	 <aec7e5c30903171858w12a9ee5bl4f3590d1a25a9971@mail.gmail.com>
	 <49C84060.6010903@mnementh.co.uk>
	 <aec7e5c30903250156v1eb38bd7qafe1c4236d9daef@mail.gmail.com>
Date: Tue, 31 Mar 2009 11:51:11 +0900
Message-ID: <aec7e5c30903301951g792a25a2s3abef57ba59fe8ee@mail.gmail.com>
Subject: Re: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org,
       drzeus-wbsd@drzeus.cx, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 5:56 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> On Tue, Mar 24, 2009 at 11:07 AM, Ian Molton <ian@mnementh.co.uk> wrote:
>> Ideally, the MMC code would use the clock API for some of this, but I seem
>> to remember there were issues with this (cant recall what right now and its
>> 2:05 AM).
>
> No worries. For me the clock framework would be the best fit too. Not
> sure about the exact details right now, but I _do_ know that we right
> now we have nothing, so being able to use tmio_mmc as is (with posted
> patches) is a great step forward. Working out the clock framework
> details after that should be no biggie. Step by step.
>
> Or if you want me to rewrite things that's fine as well. Just let me
> know what to do. =)

Ping? Please let me know how you want me to rework the patches. Unless
they are ok as-is. Any feedback on how to rewrite them would be
greatly appreciated.

These patches should leave register accesses unchanged for the common
case. The only change is to allow using the driver with only a single
io memory area. I split out this change in two separate patches to
make review easy.

I realize that we're running late for 2.6.30-rc1, but since these
patches are isolated driver changes a later merge may be possible, I'm
not sure.

Anyway, regardless of merge timing it would be great to move forward somehow.

Thank you.

/ magnus
