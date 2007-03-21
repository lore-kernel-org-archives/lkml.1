Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbXCUOii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbXCUOii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbXCUOii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:38:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:55416 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbXCUOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:38:37 -0400
From: Christian <christiand59@web.de>
Subject: Re: [BUG 2.6.21-rc3-git9] SATA NCQ failure with Samsum HD401LJ
Date: Wed, 21 Mar 2007 15:34:30 +0100
User-Agent: KMail/1.9.6
References: <fa.wBi/iM3CKSfrll7UnPHTbU0scEQ@ifi.uio.no> <200703190808.00746.christiand59@web.de> <45FE3E23.1010705@gmail.com>
In-Reply-To: <45FE3E23.1010705@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Message-Id: <200703211534.30943.christiand59@web.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/0tnXxuVDv9+8mORXfg2Fu7Maq2dnBRSOdBAp
 sJNNeKs11Lrc6y2HWnqrxPJIZgEcVXRd5CzNXkBhcYZKqpS0pc
 fWaMVrMx4OmLOGahSoPng==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 March 2007 08:39:15 Tejun Heo wrote:
> Christian wrote:
> > Yes, for me the problem was introduced recently. I have moved around
> > terabytes (sic!) on my discs with older kernels and I never got errors.
>
> There is always the possibility of disk going bad, so it would be great
> if you can boot an older kernel and verify that the problem doesn't
> occur on it.
>
> Thanks.

I've tested multiple kernels (including -mm series) in the range of 2.6.19.7
(before sata_nv adma support went in) up to 2.6.20-rc4.
Every NCQ enabled kernel I've tested showed ata errors in dmesg. So I came to 
the conclusion that my system was faulty. I ran memtest86+ for a long time, 
but no errors were found. After some fiddling with my HW I discovered that 
the nforce chipset fan induced some kind of electro magnetic interference to 
the southbridge, which could clearly be heard as a low frequency noise if I 
plugged in my speakers to the onboard sound. After replacing the fan, my 
system is stable again. Now running 2.6.21-rc3-mm2+rsdlv31 without errors. 
Really strange problem he ;-)

-Christian
