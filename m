Return-Path: <linux-kernel-owner+w=401wt.eu-S1762515AbXHABFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762515AbXHABFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760914AbXHABFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:05:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:27606 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760240AbXHABFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L6Pfkz8Hh0Kdy1Rn7pWrz8KTXpvuDIdlfaJ2aCu9oKhLpFEPbtt2Jga2lTYzjt3alSSNw/DC3gHmsfNKoejXLcnVOnvcU9R4HPiTMkHipxRWAVgVJycj7A+PeGIm7IQfnom6eln1IHO84mS1Nzq5hyzR4y00HLv5TxNloQqDXio=
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
	mode
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>
In-Reply-To: <46AFCCBB.70307@gentoo.org>
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org>
	 <20070630154230.4ad373fa.akpm@linux-foundation.org>
	 <4690E65B.5050607@gentoo.org>
	 <20070708111404.1486e73c.akpm@linux-foundation.org>
	 <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org>
	 <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org>
	 <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org>
	 <4693CCC6.7050400@zytor.com>  <46AFCCBB.70307@gentoo.org>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 09:04:54 +0800
Message-Id: <1185930294.4688.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 19:58 -0400, Daniel Drake wrote:
> Hi,
> 
> H. Peter Anvin wrote:
> >> So, 2.6.22-rc6-mm1 should work fine with CONFIG_FIRMWARE_EDID=y, or are
> >> further patches needed?
> >>
> > 
> > It should, yes.
> 
> It didn't work, and the bug still exists in 2.6.23-rc1: the resolution 
> is wrong by 6 pixels. The user does have CONFIG_FIRMWARE_EDID enabled.
> 
> So far the only known working setups since 2.6.20.11 are:
>   1. Zwane's patch reverted
>   2. Jan's patch applied (to 2.6.22 or lower, I guess it no longer works 
> for 2.6.23)
> 
> Here is dmesg output from 2.6.23:
> http://bugs.gentoo.org/attachment.cgi?id=126203&action=view
> 

The dmesg ouput did show that intelfb was not able to acquire the EDID
from the BIOS, even if CONFIG_FIRMWARE_EDID=y I presume.  I don't think
it's the VBE version, the chipset is an Intel 830 which should at least
be a VBE 2.0.

Is it the same for the working kernel?  Do you have a link to the dmesg
ouput of a working kernel, if possible with #define DEBUG in
drivers/video/fbmon.c.  The output of read-edid or /var/log/X?.log will
also be helpful.

Tony 


