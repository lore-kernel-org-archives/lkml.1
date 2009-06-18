Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbZFRK3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbZFRK3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 06:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbZFRK3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 06:29:02 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:49899 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbZFRK3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 06:29:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uyiZ29Uq8781vw/peZWhx+Dj9aDsRgsPmQ6os25eu9fQ/1JVSO8RL1v9nja2tP1TQc
         qexmgdJEXHGFngFuBUU5zjCrjJhb4EqI2f6OSoa13k/GvDP3Pcr1c+YXK9ZzGLvhQFjG
         HB5MFIRpliB0S5DFL4M43g3DxOKZVM0OGcZzA=
MIME-Version: 1.0
In-Reply-To: <cone.1245309039.632882.31537.1000@arca>
References: <20090604211103.4214303f.peter@piie.net>
	 <cone.1245086149.988051.6046.1000@deskpiie>
	 <20090616060107.GA4752@liondog.tnic> <200906160747.04094.edt@aei.ca>
	 <20090616205747.GA6356@rhlx01.hs-esslingen.de>
	 <20090617001435.e2d86780.peter@piie.net>
	 <20090617122022.GA13141@rhlx01.hs-esslingen.de>
	 <cone.1245309039.632882.31537.1000@arca>
Date: Thu, 18 Jun 2009 12:29:02 +0200
Message-ID: <9ea470500906180329w7c8975b0ra60fa219221d53f6@mail.gmail.com>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>, Ed Tomlinson <edt@aei.ca>,
       akpm@linux-foundation.org, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 18, 2009 at 9:10 AM, Peter Feuerer<peter@piie.net> wrote:
> Hi Andreas, Hi Boris,
>
> Andreas Mohr writes:
>
>>> o suspend stops and resume starts the kernelmode in a clean way
>>
>> Didn't someone argue that pre_suspend_kernelmode was unnecessary?
>> It's still in there. (could be submitted together with the
>> Kconfig ACPI depends ;)
>
> Actually I think pre_suspend_kernelmode is needed, so it won't be dropped.

and it is needed, because...?

> I'll add the ACPI dependency to Kconfig and submit the patch to lkml
> and directly to Linus, as Len doesn't seem to react?! - Boris what do
> you think? I mean, even if there's a problem with suspend / resume,
> this can also be fixed after the merge window, while all those release
> candidates are done.

Nope, this has to be fixed before submission. The merge window is open,
I think, until mid next week so there's plenty of time.

-- 
Regards/Gruss,
Boris
