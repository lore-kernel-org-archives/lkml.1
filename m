Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYGWAqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYGWAqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYGWAqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:46:17 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:41997 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYGWAqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:46:17 -0400
Date: Tue, 22 Jul 2008 20:46:00 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Floppy access by dd fails for 2.6.26-rc2 to final,
 possibly even earlier
In-reply-to: <20080722164039.GA18079@animx.eu.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200807222046.00476.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200807220841.27796.gene.heskett@gmail.com>
 <20080722164039.GA18079@animx.eu.org>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008, Wakko Warner wrote:
>Gene Heskett wrote:
>> I just been advised by private email that I an not the only one who has
>> lost the use of his floppy drive via dd.  The corresponder noted that he
>> had a copy of DSL with a 2.4.something kernel, and his drive worked
>> flawlessly while booted to DSL.
>>
>> So now there are at least 2 floppy users wandering in the wilderness
>> looking for water.  We need it to support 20 year old computers without a
>> TCP stack or network cards.
>
>I guess I'll chime in.  I'm not sure this is the same problem or not, but my
>Alpha AS1000a (EV56 5/400) has never successfully been able to read the
>floppy.  I always get garbage.  The drive does work as I can use the RCU
>from floppy from the Arc BIOS.
>
>Linux sees this device as a 2.88mb floppy.  It is a 1.44mb and the
>information in the Arc BIOS is set to 1.44mb (I don't think it matters, I
>boot from SRM, not sure how to set the floppy there)
>
>I also do not see any errors or other useful messages in the logs.
>
Neither do I. It registers as
Jul 20 22:56:59 coyote kernel: [   16.297661] Floppy drive(s): fd0 is 1.44M
Jul 20 22:56:59 coyote kernel: [   16.312758] FDC 0 is a post-1991 82077


>Jun  1 15:23:06 narf kernel: [4262383.309846] Floppy drive(s): fd0 is 2.88M
>Jun  1 15:23:06 narf kernel: [4262383.324494] FDC 0 is a National
> Semiconductor PC87306
>
>I tried forcing to use a specific type:
>Jun  1 16:21:38 narf kernel: [4194206.301784] floppy0: setting CMOS code to
> 4 Jun  1 16:21:38 narf kernel: [4194206.301784] Floppy drive(s): fd0 is
> 1.44M Jun  1 16:21:38 narf kernel: [4194206.314479] FDC 0 is a National
> Semiconductor PC87306
>
>But that failed even worse with errors on sector 0.  (NOTE the floppy was
>good)

Glad to know I'm not the only one, there are 3 of us now.

Thanks Wakko.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Absence makes the heart grow fonder.
		-- Sextus Aurelius
